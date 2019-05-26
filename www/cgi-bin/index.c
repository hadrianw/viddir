#if 0
exec gcc -std=c99 -Wall -Wextra -pedantic index.c -o index
#endif

#define _XOPEN_SOURCE 500
#define _GNU_SOURCE
#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

struct elem {
	char *name;
	long mtime;
};

struct array {
	struct elem *buf;
	int len;
	int size;
};

static void
push(struct array *array, const char *name, long mtime)
{
	array->len++;
	if(array->len > array->size) {
		array->size *= 2;
		array->buf = reallocarray(
			array->buf,
			array->size,
			sizeof(array->buf[0])
		);
	}
	array->buf[array->len - 1].name = strdup(name);
	array->buf[array->len - 1].mtime = mtime;
}

static struct array array = {.size = 16};

static int
step(const char *path, const struct stat *sb, int flag, struct FTW *ftwbuf)
{
	if(flag == FTW_F || flag == FTW_SL) {
		push(&array, &path[ftwbuf->base], sb->st_mtime);
	}
	return 0;
}

static int
compar(const void *a, const void *b)
{
	const struct elem *A = a;
	const struct elem *B = b;
	return A->mtime - B->mtime;
}

int
main(int argc, char *argv[])
{
	const char *dir = argv[1];
	int page = atoi(argv[2]);
	int perpage = atoi(argv[3]);

	array.buf = reallocarray(
		array.buf,
		array.size,
		sizeof(array.buf[0])
	);
	
	nftw(argv[1], step, 2, FTW_PHYS);
	qsort(array.buf, array.len, sizeof(array.buf[0]), compar);

	for(int i = (page-1) * perpage; i < array.len && i < page * perpage; i++) {
		/*
		const char *thumb = malloc(strlen("thumbs/") + strlen(array.buf[i].name));
		strcat(thumb, "thumbs/");
		strcat(thumb, array.buf[i].name);

		struct stat sb;
		stat(thumb, &sb);
		*/

		printf("<li><a href=\"/cgi-bin/video.sh/%s\">\n"
			"<img src=\"/cgi-bin/thumb.sh/%s\" alt=\"%s\">\n"
			"\t%s</a>\n",
			array.buf[i].name,
			array.buf[i].name, array.buf[i].name,
			array.buf[i].name);
		//printf("%ld %s\n", array.buf[i].mtime, array.buf[i].name);
	}
	return 0;
}

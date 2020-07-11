/* Runs XOR encryption over the input stream using a 32-bit key.
 * This program is designed to work as part of a pipeline only.
 *
 * Copyright (C) 2012-2020 by Jody Bruchon <jody@jodybruchon.com>
 * Licensed under The MIT License
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

#ifndef BUFSIZE
#define BUFSIZE 65536
#endif

/* Comment this out to remove the random key generator */
#ifndef NOKEYGEN
#define KEYGEN
#endif

int main(int argc, char **argv)
{
	uint32_t key = 0;
	char *q = (char *)argv[1] + 7;
	unsigned char *buf;
	unsigned int i, ctr;
	uint32_t *ibuf;

#ifdef KEYGEN
	if (argc == 2 && (strcmp(argv[1], "-g") == 0)) {
		srand((unsigned int)time(NULL) ^ 0xdeadbeef);
		i = 0;
		while (i == 0) i = rand();
		printf("%x\n", i);
		exit(0);
	}
#endif

	if ((argc < 2) || (strlen(argv[1]) != 8)) {
		fprintf(stderr, "XOR encrypting tool by Jody Bruchon <jody@jodybruchon.com>\n");
		fprintf(stderr, "You must provide an 8-character hex key.\n");
#ifdef KEYGEN
		fprintf(stderr, "Use the -g switch to get a randomly generated key.\n");
#endif
		exit(1);
	}

	/* Convert 8 lowercase hex characters to a 32-bit integer key */
	for (ctr = 0; ctr < 8; ctr++) {
		if (!((*q < 0x3a && *q > 0x2f) || (*q < 0x67 && *q > 0x60))) {
			fprintf(stderr, "Only characters 0-9, a-f are valid.\n");
			exit(1);
		}
		if (*q < 0x3a) *q -= 0x30;  /* 0-9 */
		if (*q > 0x60) *q -= 0x57;  /* a-f */
		key += (*q << (ctr * 4));
		q--;
	}

	if (key == 0) {
		fprintf(stderr, "The key must be greater than zero.\n");
		exit(1);
	}

	buf = malloc(BUFSIZE*sizeof(char));
	i = 1;
	while (i > 0) {
		i = fread(buf, 1, BUFSIZE, stdin);
		ibuf = (uint32_t *)buf;
		for (ctr = 1; ctr < BUFSIZE; ctr += sizeof(int)) {
			*ibuf ^= key;
			ibuf++;
		}
		if (i > 0) {
			if (fwrite(buf, 1, i, stdout) < i) {
				fprintf(stderr, "xorpipe: error writing to output\n");
				exit(1);
			}
		}
	}
	exit(0);
}

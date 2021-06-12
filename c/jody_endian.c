/*
 * Detect endianness at runtime and provide conversion functions
 * Version 1.0 (2015-11-08)
 *
 * Copyright (C) 2015-2021 by Jody Bruchon <jody@jodybruchon.com>
 * Released under The MIT License
 */

#include <stdint.h>

/* Returns 1 for little-endian, 0 for big-endian */
int detect_endianness(void)
{
	union {
		uint32_t big;
		uint8_t p[4];
	} i = {0x76543210};

	if (i.p[0] == 0x76) return 0;
	else return 1;

}

uint16_t u16_endian_reverse(const uint16_t x)
{
	union {
		uint16_t big;
		uint8_t p[2];
	} in;
	union {
		uint16_t big;
		uint8_t p[2];
	} out;

	in.big = x;

	out.p[0] = in.p[1];
	out.p[1] = in.p[0];

	return out.big;
}

uint32_t u32_endian_reverse(const uint32_t x)
{
	union {
		uint32_t big;
		uint8_t p[4];
	} in;
	union {
		uint32_t big;
		uint8_t p[4];
	} out;

	in.big = x;

	out.p[0] = in.p[3];
	out.p[1] = in.p[2];
	out.p[2] = in.p[1];
	out.p[3] = in.p[0];

	return out.big;
}

uint64_t u64_endian_reverse(const uint64_t x)
{
	union {
		uint64_t big;
		uint8_t p[8];
	} in;
	union {
		uint64_t big;
		uint8_t p[8];
	} out;

	in.big = x;

	out.p[0] = in.p[7];
	out.p[1] = in.p[6];
	out.p[2] = in.p[5];
	out.p[3] = in.p[4];
	out.p[4] = in.p[3];
	out.p[5] = in.p[2];
	out.p[6] = in.p[1];
	out.p[7] = in.p[0];

	return out.big;
}

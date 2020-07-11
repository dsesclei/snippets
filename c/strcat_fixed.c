/* Fast strcat() implementations for when string lengths are known
 *
 * Copyright (C) 2015-2020 by Jody Bruchon <jody@jodybruchon.com>
 * Released under The MIT License
 */

#include <string.h>
#include <sys/types.h>

size_t strcat_fixed(char * const dest, size_t dlen, const char *src, size_t slen)
{
	char * const restrict tail = dest + dlen;
	const size_t length = dlen + slen;

	/* Empty concatenation string */
	if (slen == 0) return dlen;

	/* Fast 1-byte concatenation */
	if (slen == 1) {
		*tail = *src;
		*(tail + 1) = '\0';
		return length;
	}
	
	/* Normal concatenation */
	memcpy(tail, src, slen);

	return length;
}

/* Fast strcat() implementations for when string lengths are known
 *
 * Copyright (C) 2015-2021 by Jody Bruchon <jody@jodybruchon.com>
 * See strcat_fixed.c for license information
 */

#ifndef STRCAT_FIXED_H
#define STRCAT_FIXED_H

#ifdef __cplusplus
extern "C" {
#endif

extern size_t strcat_fixed(char * const dest, size_t dlen, const char *src, size_t slen);

#ifdef __cplusplus
}
#endif

#endif	/* STRCAT_FIXED_H */

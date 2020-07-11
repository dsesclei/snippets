/*
 * Jody Bruchon's two-way strstr() function
 *
 * Copyright (C) 2014-2020 by Jody Bruchon <jody@jodybruchon.com>
 * See jody_strstr.c for license information
 */

#include <stdio.h>
#include <string.h>

#ifndef JODY_STRSTR_H
#define JODY_STRSTR_H

#ifdef __cplusplus
extern "C" {
#endif

extern char *jody_strstr(const char *s1, const char *s2);

#ifdef __cplusplus
}
#endif

#endif	/* JODY_STRSTR_H */

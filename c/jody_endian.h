/* Detect endianness at runtime and provide conversion functions
 * Version 1.0 (2015-11-08)
 *
 * Copyright (C) 2015-2021 by Jody Bruchon <jody@jodybruchon.com>
 * See jody_endian.c for license information
 */

int detect_endianness(void);
uint16_t u16_endian_reverse(const uint16_t x);
uint32_t u32_endian_reverse(const uint32_t x);
uint64_t u64_endian_reverse(const uint64_t x);

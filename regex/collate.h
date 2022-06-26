/*-
 * Hacked up substitute for collate.h, which is a hook into the FreeBSD
 * internationalisation code. This means things like [:upper:] won't work
 * correctly, but I need to rewrite the internationalisation code for REs
 * for that to work in any case.
 */

#ifndef _COLLATE_H_
#define	_COLLATE_H_

#define __collate_load_error 0
#define	__collate_range_cmp(x, y) ((int)x - (int)y)

#endif /* !_COLLATE_H_ */

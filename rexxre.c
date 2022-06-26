/* regular expression routines for rexx
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * The Original Code is regutil.
 *
 * The Initial Developer of the Original Code is Patrick TJ McPhee.
 * Portions created by Patrick McPhee are Copyright © 2003
 * Patrick TJ McPhee. All Rights Reserved.
 *
 * Contributors:
 *
 * $Header: C:/ptjm/rexx/rexxre/RCS/rexxre.c 1.8 2003/05/26 19:42:46 ptjm Rel $
 */

/* these routines are based on POSIX regular expressions. IBM's Object Rexx
 * includes a regular expression object which is NOT based on POSIX regular
 * expressions, but is confusingly similar. I'm not currently supporting
 * that because I don't know what's in it ... */

#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <regex.h>
#include "rxproto.h"

/* routines: recomp -- compiles a regular expression
 *           reexec -- applies a regular expression to a string
 *           refree -- releases the compiled regular expression
 *           reerror -- explains error codes
 *           reparse -- parses a value according to a regular expression
 *           reversion -- returns the library version number
 *           reloadfuncs -- loads all the other functions
 *           redropfuncs -- unloads all the functions
 */

typedef struct {
   char failureflag[2];
   int  rc;
   regex_t re;
} cre_t;

#define REMAGIC 29


/* compile regular expression -- arguments are the RE and flags.
 * return code is the compiled regular expression.
 * flags are `x' to get extended regular expressions
 *           `c' to get case-sensitive comparisons
 *           `s' to get status-only (no position)
 *           `n' to have newlines take on a special meaning */
rxfunc(recomp)
{
   cre_t reg;
   int flags = REG_BASIC|REG_ICASE;
   char * re;
   register int i, rc;
   
   checkparam(1, 2);

   rxstrdup(re, argv[0]);
   if (argc > 1) {
      for (i = 0; i < argv[1].strlength; i++) {
         switch (argv[1].strptr[i]) {
            case 'X':
            case 'x': flags |= REG_EXTENDED; break;
            case 'C':
            case 'c': flags &= ~REG_ICASE; break;
            case 'S':
            case 's': flags |= REG_NOSUB; break;
            case 'N':
            case 'n': flags |= REG_NEWLINE; break;
            default: return BADARGS; break;
         }
      }
   }

   reg.rc = regcomp(&reg.re, re, flags);

   if (!reg.rc) {
      reg.failureflag[0] = '0';
   }
   else {
      reg.failureflag[0] = '1';
   }

   reg.failureflag[1] = REMAGIC;

   memcpy(result->strptr, &reg, sizeof(reg));
   result->strlength = sizeof(reg);

   return 0;
}

/* reexec(re, string[, matches[, flags]])
 *  flags are `b' -- the string does not start at the beginning of a line
 *            `e' -- the string does not start at the end of a line
 *            `p' -- return the positions of matched strings, rather than the strings
 *                   themselves */
rxfunc(reexec)
{
   cre_t * reg, dreg;
   int flags = 0, cflags = REG_BASIC|REG_ICASE;
   int retstr = 1;
   int rc;
   register int i;
   char * str;
   RXSTRING fullmatch;
   static const char fullmatchcomposite[] = "!MATCH";
   regmatch_t * rmt = NULL;;
   
   checkparam(2, 4);

   if (argv[0].strlength == 0) {
      return BADARGS;
   }

   if (argc == 4) {
      for (i = 0; i < argv[3].strlength; i++) {
         switch (argv[3].strptr[i]) {
            case 'X':
            case 'x': cflags |= REG_EXTENDED; break;
            case 'C':
            case 'c': cflags &= ~REG_ICASE; break;
            case 'S':
            case 's': cflags |= REG_NOSUB; break;
            case 'N':
            case 'n': cflags |= REG_NEWLINE; break;

            case 'B':
            case 'b': flags |= REG_NOTBOL; break;
            case 'E':
            case 'e': flags |= REG_NOTEOL; break;
            case 'P':
            case 'p': retstr = 0; break;
            default: return BADARGS;
         }
      }
   }


   /* guess whether this is a compiled RE -- anything which isn't the
    * right size size definitely isn't, and anything which is the right
    * size bug doesn't have the right magic numbers in the first few
    * characters probably aren't
    */
   if (argv[0].strlength != sizeof(*reg) || argv[0].strptr[1] != REMAGIC ||
       (argv[0].strptr[0] != '0' && argv[0].strptr[0] != '1')) {
      rxstrdup(str, argv[0]);
      reg = &dreg;
      reg->rc = regcomp(&reg->re, str, cflags);

      /* too bad -- there's no way to know why it failed */
      if (reg->rc) {
         regfree(&reg->re);
         result_zero();
         return 0;
      }
   }

   else {
      reg = (cre_t *)argv[0].strptr;
   }

   rmt = calloc(sizeof(*rmt), reg->re.re_nsub+1);
   if (!rmt) {
      if (reg == &dreg)
         regfree(&reg->re);
      return NOMEMORY;
   }

   str = malloc(argv[1].strlength + 1);
   if (!str) {
      free(rmt);
      if (reg == &dreg)
         regfree(&reg->re);
      return NOMEMORY;
   }

   memcpy(str, argv[1].strptr, argv[1].strlength);
   str[argv[1].strlength] = 0;
   
   rc = regexec(&reg->re, str, reg->re.re_nsub+1, rmt, flags);

   if (rc == 0) {
      result_one();
   }
   else {
      result_zero();
   }
   
   if (argc > 2 && argv[2].strptr) {
      chararray * ca = new_chararray();

      if (retstr) {
         for (i = 1; i < reg->re.re_nsub+1; i++) {
            cha_adddummy(ca, str+rmt[i].rm_so, rmt[i].rm_eo-rmt[i].rm_so);
         }
      }
      else {
         char buf[40];
         int bufl;

         for (i = 1; i < reg->re.re_nsub+1; i++) {
            bufl = sprintf(buf, "%d %d", (int)rmt[i].rm_so+1, (int)rmt[i].rm_eo - rmt[i].rm_so);
            cha_addstr(ca, buf, bufl);
         }
      }

      setastem(argv+2, ca);
      delete_chararray(ca);

      fullmatch.strptr = alloca(argv[2].strlength+sizeof(fullmatchcomposite)+1);
      memcpy(fullmatch.strptr, argv[2].strptr, argv[2].strlength);
      if (fullmatch.strptr[argv[2].strlength-1] == '.') {
         fullmatch.strlength = argv[2].strlength;
      }
      else {
         fullmatch.strptr[argv[2].strlength] = '.';
         fullmatch.strlength = argv[2].strlength + 1;
      }

      memcpy(fullmatch.strptr+fullmatch.strlength, fullmatchcomposite,
             sizeof(fullmatchcomposite)-1);
      fullmatch.strlength += sizeof(fullmatchcomposite)-1;

      if (retstr) {
         setavar(&fullmatch, str+rmt[0].rm_so, rmt[0].rm_eo-rmt[0].rm_so);
      }
      else {
         char buf[40];
         int bufl;
         bufl = sprintf(buf, "%d %d", (int)rmt[0].rm_so+1, (int)rmt[0].rm_eo - rmt[0].rm_so);
         setavar(&fullmatch, buf, bufl);
      }
   }

   if (rmt) {
      free(rmt);
   }

   if (reg == &dreg)
      regfree(&reg->re);

   free(str);

   return 0;
}

/* refree(re) */
rxfunc(refree)
{
   cre_t * reg;
   register int i;

   checkparam(1, 1000);

   for (i = 0; i < argc; i++) {
      if (argv[i].strlength != sizeof(*reg)) {
         return BADARGS;
      }

      reg = (cre_t *)argv[i].strptr;

      regfree(&reg->re);
   }

   result_zero();
   return 0;
}

/* reerror(re) */
rxfunc(reerror)
{
   cre_t * reg;

   checkparam(1, 1);

   if (argv[0].strlength != sizeof(*reg)) {
      return BADARGS;
   }

   reg = (cre_t *)argv[0].strptr;


   result->strlength = regerror(reg->rc, &reg->re, result->strptr, DEFAULTSTRINGSIZE);

   return 0;
}

/* reparse(expression, value, flags, varname[, varname, ...])
 *   flags are:
 *       'x': use extended regular expressions;
 *       'c': respect case
 *       'n': newlines denote line-ends
 *       's': match variables to sub-expressions
 *       'd': re is the value delimiter (default)
 *       'v': re matches a var
 *       't': first var is a stem for all the fields
 */
rxfunc(reparse)
{
   cre_t * reg, dreg;
   regmatch_t * rmt;
   register int i, j, oldi, voldi, sd;
   int flags = REG_BASIC|REG_ICASE, rc;
   enum { sub, var, delim } matchmode = delim;
   char * str, *re;
   chararray * ca = NULL;
   
   checkparam(4, 10000);

   if (argc > 3) {
      for (i = 0; i < argv[2].strlength; i++) {
         switch (argv[2].strptr[i]) {
            case 'X':
            case 'x': flags |= REG_EXTENDED; break;
            case 'C':
            case 'c': flags &= ~REG_ICASE; break;
            case 'N':
            case 'n': flags |= REG_NEWLINE; break;
            case 'S':
            case 's': matchmode = sub; break;
            case 'D':
            case 'd': matchmode = delim; break;
            case 'V':
            case 'v': matchmode = var; break;
            case 'T':
            case 't': ca = new_chararray(); break;
            default: return BADARGS; break;
         }
      }
   }

   /* guess whether this is a compiled RE -- anything which isn't the
    * right size size definitely isn't, and anything which is the right
    * size bug doesn't have the right magic numbers in the first few
    * characters probably aren't
    */
   if (argv[0].strlength != sizeof(*reg) || argv[0].strptr[1] != REMAGIC ||
       (argv[0].strptr[0] != '0' && argv[0].strptr[0] != '1')) {
      rxstrdup(re, argv[0]);
      reg = &dreg;
      reg->rc = regcomp(&reg->re, re, flags);

      /* too bad -- there's no way to know why it failed */
      if (reg->rc) {
         regfree(&reg->re);
         result_zero();
         return 0;
      }
   }

   else {
      reg = (cre_t *)argv[0].strptr;
   }

   str = malloc(argv[1].strlength+1);
   if (!str) {
      if (reg == &dreg)
         regfree(&reg->re);
      return NOMEMORY;
   }

   memcpy(str, argv[1].strptr, argv[1].strlength);
   str[argv[1].strlength] = 0;

   rmt = calloc(sizeof(*rmt), reg->re.re_nsub+1);
   if (!rmt) {
      free(str);
      if (reg == &dreg)
         regfree(&reg->re);
      return NOMEMORY;
   }

   result_zero();
   j = 0;
   switch (matchmode) {
      case sub: {
         rc = regexec(&reg->re, str, reg->re.re_nsub+1, rmt, 0);
         if (!rc) {
            result_one();
            if (ca) {
               for (i = 1; i < (reg->re.re_nsub+1); i++) {
                  cha_adddummy(ca, str+rmt[i].rm_so, rmt[i].rm_eo-rmt[i].rm_so);
               }
            }
            else {
               for (i = 1, j = 3; i < (reg->re.re_nsub+1) && j < argc; i++, j++) {
                  setavar(argv+j, str+rmt[i].rm_so, rmt[i].rm_eo-rmt[i].rm_so);
               }
            }
         }
      }
         break;
      case var: {
         for (rc = regexec(&reg->re, str, reg->re.re_nsub+1, rmt, 0), j = 3, i = voldi = sd = 0, oldi = -1;
              !rc && (ca || j < argc);
              i += sd + rmt[0].rm_eo, rc = regexec(&reg->re, str+i, reg->re.re_nsub+1, rmt, 0), j++) {
            result_one();

            /* If the end offset doesn't move, we need to advance over
             * the next character to avoid a hang.
             * If it doesn't move and we're starting from the end of the
             * previous match, then we've just matched the same thing twice
             * and should ignore this one.
             */
            if (sd = !rmt[0].rm_eo) {
               if (i == oldi) {
                  if (!str[i]) {
                     break;
                  }
                  else {
                     j--;
                     continue;
                  }
               }
               else if (!str[i]) {
                  sd = 0;
               }
            }

            if (ca)
               cha_addstr(ca, str+i+rmt[0].rm_so, rmt[0].rm_eo-rmt[0].rm_so);
            else
               setavar(argv+j, str+i+rmt[0].rm_so, rmt[0].rm_eo - rmt[0].rm_so);

            voldi = oldi;
            oldi = i + (int)rmt[0].rm_eo;
         }

         /* to match the behaviour of the parse expression, we map everything
          * that's left to the last field */
         if (!ca) {
            if (j == argc) {
               setavar(argv+j-1, str+voldi, argv[1].strlength - voldi);
            }
            else if (rc) {
               argc--;
               setavar(argv+argc, str+i, argv[1].strlength - i);
            }
         }
      }
         break;
      case delim: {
         /* we always match by definition, since the field is whatever
          * doesn't match the delimiter */
         result_one();
         for (rc = regexec(&reg->re, str, reg->re.re_nsub+1, rmt, 0), j = 3, i = 0, oldi = -1, voldi = 0;
              !rc && (ca || j < argc);
              i += sd + rmt[0].rm_eo, rc = regexec(&reg->re, str+i, reg->re.re_nsub+1, rmt, 0), j++) {

            /* same argument about matching zero-length strings applies here,
             * although it would be perverse to allow a zero-length
             * delimiter */
            if (sd = !rmt[0].rm_eo) {
               if (i == oldi) {
                  if (!str[i]) {
                     break;
                  }
                  else {
                     j--;
                     continue;
                  }
               }
               else if (!str[i]) {
                  sd = 0;
               }
            }

            if (ca)
               cha_addstr(ca, str+i, rmt[0].rm_so);
            else
               setavar(argv+j, str+i, rmt[0].rm_so);

            voldi = oldi;
            oldi = i + (int)rmt[0].rm_eo;
         }

         /* to match the behaviour of the parse expression, we map everything
          * that's left to the last field */
         if (!ca) {
            if (j == argc) {
               j--;
               i = voldi;
            }

            setavar(argv+j, str+i, argv[1].strlength - i);
            j++;
         }
         else {
            cha_addstr(ca, str+i, argv[1].strlength - i);
         }
      }
         break;
   }

   if (ca) {
      setastem(argv+3, ca);
      delete_chararray(ca);
   }
   else {
      for (; j < argc; j++) {
         setavar(argv+j, "", 0);
      }
   }


   if (reg == &dreg)
      regfree(&reg->re);

   free(rmt);
   free(str);

   return 0;
}

rxfunc(reversion)
{
   static const char version[] = "1.0.1";
   memcpy(result->strptr, version, sizeof(version)-1);
   result->strlength = sizeof(version) - 1;
   return 0;
}


rxfunc(reloadfuncs);
rxfunc(redropfuncs);

struct {
    char * name;
    APIRET (APIENTRY*funcptr)(PUCHAR fname, ULONG argc, PRXSTRING argv, PSZ pSomething, PRXSTRING result);
} funclist[] = {
    {"RECOMP", recomp},
    {"REEXEC", reexec},
    {"REFREE", refree},
    {"REERROR", reerror},
    {"REPARSE", reparse},
    {"REVERSION", reversion},
    {"REDROPFUNCS", redropfuncs},
    {"RELOADFUNCS", reloadfuncs}
};

/* reloadfuncs() */
rxfunc(reloadfuncs)
{
    register int i;

    checkparam(0,0);

    for (i = 0; i < DIM(funclist); i++) {
	RexxRegisterFunctionExe(funclist[i].name, funclist[i].funcptr);
    }

    result_zero();

    return 0;
}

/* redropfuncs() */
rxfunc(redropfuncs)
{
    register int i;
    checkparam(0,0);

    for (i = 0; i < DIM(funclist); i++) {
	RexxDeregisterFunction(funclist[i].name);
    }

    result_zero();
    return 0;
}

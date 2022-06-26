# Unix Makefile for RexxRE

# You are meant to set the P variables (PDEBUG et al) in a platform-
# specific Makefile, then include Makefile.inc from that other file

#  The contents of this file are subject to the Mozilla Public License
#  Version 1.1 (the "License"); you may not use this file except in
#  compliance with the License. You may obtain a copy of the License at
#  http://www.mozilla.org/MPL/

#  Software distributed under the License is distributed on an "AS IS"
#  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
#  License for the specific language governing rights and limitations
#  under the License.

#  The Original Code is RexxRE.

#  The Initial Developer of the Original Code is Patrick TJ McPhee.
#  Portions created by Patrick McPhee are Copyright © 2003
#  Patrick TJ McPhee. All Rights Reserved.

#  Contributors:

# $Header: C:/ptjm/rexx/rexxre/RCS/Makefile.inc 1.1 2003/04/29 16:16:36 ptjm Rel $

DEBUG=-g $(PDEBUG)
OPT=

REXX_INCLUDE=$(HOME)/regina
CFLAGS=$(DEBUG) $(OPT) $(PCFLAGS) $(PCDEFS) -I $(REXX_INCLUDE)
LDFLAGS=$(PLDFLAGS)
LIBS=$(PLIBS)
PROJECT=rexxre
LIBFILE=lib$(PROJECT).so

OBJS=$(PROJECT).o rxsupport.o

$(LIBFILE) : $(OBJS)
	$(LD) $(LDFLAGS) -o$(LIBFILE) $(OBJS)


dist:
	$(MAKE) $(MAKEFLAGS) OPT="$(POPT)" DEBUG=""


clean:
	-rm $(OBJS) $(LIBFILE) $(PCLEAN)



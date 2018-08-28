############################################################################
# apps/external/nghttp2/Makefile
#
#   Copyright 2018 Sony Video & Sound Products Inc.
#   Author: Masayuki Ishikawa <Masayuki.Ishikawa@jp.sony.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name NuttX nor the names of its contributors may be
#    used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
############################################################################

-include $(TOPDIR)/.config
-include $(TOPDIR)/Make.defs
include $(APPDIR)/Make.defs

OPENSSLDIR = $(APPDIR)/external/openssl

CFLAGS += -I ./lib/includes
CFLAGS += -I$(OPENSSLDIR)/include
CFLAGS += -DNUTTX -DHAVE_CONFIG_H
#CFLAGS += -DDEBUGBUILD

ASRCS	=
CSRCS	=

ifeq ($(CONFIG_EXTERNAL_NGHTTP2),y)
CSRCS += lib/nghttp2_buf.c
CSRCS += lib/nghttp2_callbacks.c
CSRCS += lib/nghttp2_debug.c
CSRCS += lib/nghttp2_frame.c
CSRCS += lib/nghttp2_hd.c
CSRCS += lib/nghttp2_hd_huffman_data.c
CSRCS += lib/nghttp2_hd_huffman.c
CSRCS += lib/nghttp2_helper.c
CSRCS += lib/nghttp2_http.c
CSRCS += lib/nghttp2_map.c
CSRCS += lib/nghttp2_mem.c
CSRCS += lib/nghttp2_npn.c
CSRCS += lib/nghttp2_option.c
CSRCS += lib/nghttp2_outbound_item.c
CSRCS += lib/nghttp2_pq.c
CSRCS += lib/nghttp2_priority_spec.c
CSRCS += lib/nghttp2_queue.c
CSRCS += lib/nghttp2_rcbuf.c
CSRCS += lib/nghttp2_session.c
CSRCS += lib/nghttp2_stream.c
CSRCS += lib/nghttp2_submit.c
CSRCS += lib/nghttp2_version.c
endif

AOBJS		= $(ASRCS:.S=$(OBJEXT))
COBJS		= $(CSRCS:.c=$(OBJEXT))

SRCS		= $(ASRCS) $(CSRCS)
OBJS		= $(AOBJS) $(COBJS)

ifeq ($(CONFIG_WINDOWS_NATIVE),y)
  BIN		= $(TOPDIR)\staging\libnghttp2$(LIBEXT)
else
ifeq ($(WINTOOL),y)
  BIN		= $(TOPDIR)\\staging\\libnghttp2$(LIBEXT)
else
  BIN		= $(TOPDIR)/staging/libnghttp2$(LIBEXT)
endif
endif

ROOTDEPPATH	= --dep-path .

# Common build

VPATH		=

all: .built
.PHONY: context depend clean distclean preconfig
.PRECIOUS: $(TOPDIR)/staging/libnghttp2$(LIBEXT)

$(AOBJS): %$(OBJEXT): %.S
	$(call ASSEMBLE, $<, $@)

$(COBJS): %$(OBJEXT): %.c
	$(call COMPILE, $<, $@)

.built: $(OBJS)
	$(call ARCHIVE, $(BIN), $(OBJS))
	$(Q) touch .built

install:

context:

.depend: Makefile $(SRCS)
	$(Q) $(MKDEP) $(ROOTDEPPATH) "$(CC)" -- $(CFLAGS) -- $(SRCS) >Make.dep
	$(Q) touch $@

depend: .depend

clean:
	$(call DELFILE, .built)
	$(call CLEAN)

distclean: clean
	$(call DELFILE, Make.dep)
	$(call DELFILE, .depend)

preconfig:

-include Make.dep

CC?=gcc
PKG_CONFIG?=pkg-config

CFLAGS?=-g -O2 -Wall
LDFLAGS?=

PREFIX?=/usr/local
DESTDIR?=

# arch hardening
#CPPFLAGS+=-D_FORTIFY_SOURCE=2
#CFLAGS+=-march=x86-64 -mtune=generic -O2 -pipe -fno-plt
#LDFLAGS+=-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now

# arch & debian hardening workaround
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	LDFLAGS+=-Wl,--no-as-needed
endif


CFLAGS+=$(shell $(PKG_CONFIG) x11 --cflags)
LDFLAGS+=$(shell $(PKG_CONFIG) x11 --libs)

CFLAGS+=$(shell $(PKG_CONFIG) imlib2 --cflags)
LDFLAGS+=$(shell $(PKG_CONFIG) imlib2 --libs)

CFLAGS+=$(shell $(PKG_CONFIG) xinerama --cflags)
LDFLAGS+=$(shell $(PKG_CONFIG) xinerama --libs)

# to build without FVWM3 use `make LINK_FVWM3=0', default to 1
# and edit config-link-fvwm3.mk
LINK_FVWM3?=1

ifneq ($(LINK_FVWM3), 0)
include config-link-fvwm3.mk
hsetroot: CFLAGS+=-DLINK_FVWM3=1 $(FVWM3LIB_CFLAGS)
hsetroot: LDFLAGS+=$(FVWM3LIB_LDFLAGS)
else
hsetroot: CFLAGS+=-DLINK_FVWM3=0
endif

# to build without trapping Xerrors, use `make HANDLE_XERRORS=0', default
# to 1.
ifneq ($(HANDLE_XERRORS), 0)
hsetroot: CFLAGS+=-DHANDLE_XERRORS=1
else
hsetroot: CFLAGS+=-DHANDLE_XERRORS=0
endif

all: hsetroot hsr-outputs

hsetroot: hsetroot.o $(FVWM3LIB_LIB)

hsr-outputs: hsr-outputs.o

install: hsetroot hsr-outputs
	install -Dst $(DESTDIR)$(PREFIX)/bin/ hsetroot
	install -Dst $(DESTDIR)$(PREFIX)/bin/ hsr-outputs

clean:
	rm -f *.o hsetroot hsr-outputs

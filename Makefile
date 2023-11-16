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

# to build without trapping Xerrors, use `make HANDLE_XERRORS=0', default
# to 1.
ifneq ($(HANDLE_XERRORS), 0)
hsetroot: CFLAGS+=-DHANDLE_XERRORS=1
else
hsetroot: CFLAGS+=-DHANDLE_XERRORS=0
endif

all: hsetroot hsr-outputs

hsetroot: hsetroot.o

hsr-outputs: hsr-outputs.o

install: hsetroot hsr-outputs
	install -Dst $(DESTDIR)$(PREFIX)/bin/ hsetroot
	install -Dst $(DESTDIR)$(PREFIX)/bin/ hsr-outputs

clean:
	rm -f *.o hsetroot hsr-outputs

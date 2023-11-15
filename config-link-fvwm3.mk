# config-link-fvwm3.mk. -*- Makefile -*-
#
# this file should define FVWM3LIB_LIB (absolute path to the static
# library) and set up FVWM3LIB_CFLAGS FVWM3LIB_LDFLAGS which may be
# needed to compile and link it.

FVWM3LIB_CFLAGS+=$(shell $(PKG_CONFIG) --cflags freetype2) -I/7/gtk/fvwm3 -I/7/gtk/fvwm3/build
FVWM3LIB_LDFLAGS+=$(shell $(PKG_CONFIG) --cflags freetype2) -lXext -lm
FVWM3LIB_LIB=/7/gtk/fvwm3/build/libs/libfvwm3.a

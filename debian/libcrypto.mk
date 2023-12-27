include debian/sources.mk

NAME = libcrypto
SOURCES = $(crypto_sources)

amd64_SOURCES = $(linux_x86_64_sources)
arm64_SOURCES = $(linux_aarch64_sources)
armel_SOURCES = $(linux_arm_sources)
armhf_SOURCES = $(linux_arm_sources)
i386_SOURCES = $(linux_x86_sources)
ppc64el_SOURCES = $(linux_ppc64le_sources)
hurd-amd64_SOURCES = $(linux_x86_64_sources)
hurd-i386_SOURCES = $(linux_x86_sources)
kfreebsd-i386_SOURCES = $(linux_x86_sources)
kfreebsd-amd64_SOURCES = $(linux_x86_64_sources)
x32_SOURCES = $(linux_x86_64_sources)

SOURCES += $($(DEB_HOST_ARCH)_SOURCES)

SOURCES_C = $(filter %.c,$(SOURCES))
OBJECTS_C = $(SOURCES_C:.c=.o)
SOURCES_ASSEMBLY = $(filter %.S,$(SOURCES))
OBJECTS_ASSEMBLY = $(SOURCES_ASSEMBLY:.S=.o)

CFLAGS += \
  -fvisibility=hidden \
  -Wa,--noexecstack # Fixes `shlib-with-executable-stack`, see `src/util/BUILD.toplevel`

CPPFLAGS += \
  -Isrc/crypto \
  -Isrc/include \

LDFLAGS += \
  -Wl,-soname,$(NAME).so.0 \
  -lpthread \
  -shared \

ifneq ($(filter mipsel mips64el,$(DEB_HOST_ARCH)),)
  LDFLAGS += -Wl,-z,notext
endif

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
# Use gcc instead of clang for assembly on armel
CC_ASSEMBLY = $(CC)
ifeq ($(DEB_HOST_ARCH), armel)
  LDFLAGS += -latomic
  CC_ASSEMBLY = gcc
endif

build: $(OBJECTS_C) $(OBJECTS_ASSEMBLY)
	mkdir -p debian/out
	$(CC) $^ -o debian/out/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/$(NAME).so

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC_ASSEMBLY) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

include sources.mk

NAME = libcrypto
SOURCES = $(crypto_sources)

amd64_SOURCES = $(linux_x86_64_sources)
arm64_SOURCES = $(linux_aarch64_sources)
armel_SOURCES = $(linux_arm_sources)
armhf_SOURCES = $(linux_arm_sources)
i386_SOURCES = $(linux_x86_sources)
ppcel64_SOURCES = $(linux_ppc64le_sources)

SOURCES += $($(DEB_HOST_ARCH)_SOURCES)

CFLAGS+= \
  -D_XOPEN_SOURCE=700 \
  -DBORINGSSL_ANDROID_SYSTEM \
  -DBORINGSSL_IMPLEMENTATION \
  -DBORINGSSL_SHARED_LIBRARY \
  -DOPENSSL_SMALL \
  -fvisibility=hidden \
  -Wa,--noexecstack # Fixes `shlib-with-executable-stack`, see `src/util/BUILD.toplevel`

CPPFLAGS += -Isrc/include -Isrc/crypto

LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 -lpthread

build: $(SOURCES)
	mkdir --parents debian/out
	$(CC) $^ -o debian/out/$(NAME).so.0 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 debian/out/$(NAME).so
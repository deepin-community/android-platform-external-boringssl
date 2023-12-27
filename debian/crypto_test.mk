include debian/sources.mk

NAME = crypto_test

SOURCES = $(crypto_test_sources)
OBJECTS = $(SOURCES:.cc=.o)

CPPFLAGS += \
  -Isrc/include \

LDFLAGS += \
  -Ldebian/out \
  -lcrypto \
  -lgtest \
  -lpthread \
  -lssl \
  -ltest_support \
  -pie

ifneq ($(filter mipsel mips64el,$(DEB_HOST_ARCH)),)
  LDFLAGS += -Wl,-z,notext
endif

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifeq ($(DEB_HOST_ARCH), armel)
  LDFLAGS += -latomic
endif

# clang built crypto_test binary crashes on mips64el
# so fallback to gcc as workaround
ifeq ($(DEB_HOST_ARCH), mips64el)
  CXX = g++
endif

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME) $(LDFLAGS)

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

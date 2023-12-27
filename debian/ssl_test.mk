include debian/sources.mk

NAME = ssl_test

SOURCES = $(ssl_test_sources)
SOURCES_C = $(filter %.c,$(SOURCES))
OBJECTS_C = $(SOURCES_C:.c=.o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)

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

build: $(OBJECTS_C) $(OBJECTS_CC)
	$(CXX) $^ -o debian/out/$(NAME) $(LDFLAGS)

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

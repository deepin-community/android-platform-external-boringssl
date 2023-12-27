NAME = compiler_test

SOURCES = \
  err_data.c \
  src/crypto/compiler_test.cc \
  src/crypto/err/err.c \
  src/crypto/mem.c \
  src/crypto/test/test_util.cc \
  src/crypto/thread_pthread.c \

SOURCES_C = $(filter %.c,$(SOURCES))
OBJECTS_C = $(SOURCES_C:.c=.o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)

CPPFLAGS += \
  -Isrc/include \

LDFLAGS += \
  -lgtest \
  -pie

ifneq ($(filter mipsel mips64el,$(DEB_HOST_ARCH)),)
  LDFLAGS += -Wl,-z,notext
endif

build: $(OBJECTS_C) $(OBJECTS_CC) /usr/lib/$(DEB_HOST_MULTIARCH)/libgtest_main.a
	mkdir -p debian/out/test
	$(CXX) $^ -o debian/out/test/$(NAME) $(LDFLAGS)
	rm $(OBJECTS_C) $(OBJECTS_CC)

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

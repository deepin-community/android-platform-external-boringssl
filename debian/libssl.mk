include debian/sources.mk

NAME = libssl
SOURCES = $(ssl_sources)

OBJECTS = $(SOURCES:.cc=.o)

CXXFLAGS += \
  -fvisibility=hidden \

CPPFLAGS += \
  -Isrc/include \

LDFLAGS += \
  -Ldebian/out \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lcrypto \
  -shared \

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/$(NAME).so

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

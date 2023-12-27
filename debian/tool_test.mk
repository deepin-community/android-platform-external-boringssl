include debian/sources.mk

NAME = bssl-tool

SOURCES = $(tool_sources)
OBJECTS = $(SOURCES:.cc=.o)

CPPFLAGS += \
  -Isrc/include \

LDFLAGS += \
  -Ldebian/out \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -lcrypto \
  -lssl \
  -pie

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME) $(LDFLAGS)

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

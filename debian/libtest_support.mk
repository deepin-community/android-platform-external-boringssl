include debian/sources.mk

NAME = libtest_support
SOURCES = $(test_support_sources)

OBJECTS = $(SOURCES:.cc=.o)

CPPFLAGS += \
  -Isrc/include \

LDFLAGS += \
  -Wl,-soname,$(NAME).so.0 \
  -shared \

build: $(OBJECTS)
	mkdir -p debian/out
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/$(NAME).so

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

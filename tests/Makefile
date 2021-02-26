.PHONY: clean test build_dependencies
CC=g++-10
LDFLAGS=
CCFLAGS=-Wall -std=c++20 -g

CCFLAGS+= -DDEBUG -DASSERTIONS


# For internal projects placed in the `libs` folder
INTERNAL_LIBRARIES=$(wildcard ../libs/*)
INTERNAL_LIBRARY_INCLUDE_FLAGS=$(addsuffix /include, $(addprefix -I, $(INTERNAL_LIBRARIES)))

# For internal projects only for tests, placed in the `tests/libs` folder
INTERNAL_TEST_LIBRARIES=$(wildcard libs/*)
INTERNAL_TEST_LIBRARY_INCLUDE_FLAGS=$(addsuffix /include, $(addprefix -I, $(INTERNAL_TEST_LIBRARIES)))

# For including external library headers files placed in the `external_libs` folder
EXTERNAL_LIBRARY_INCLUDE_FLAGS=-I../external_libs/midifile/include

LD_INCLUDES=-I../include $(INTERNAL_LIBRARY_INCLUDE_FLAGS) $(INTERNAL_TEST_LIBRARY_INCLUDE_FLAGS) $(EXTERNAL_LIBRARY_INCLUDE_FLAGS)

.PHONY: $(INTERNAL_TEST_LIBRARIES)

LIB_NAME=name_here

LD_LIBS=-L../lib -l$(LIB_NAME)
LDTEST_LIBS=$(addsuffix /lib, $(addprefix -L, $(INTERNAL_TEST_LIBRARIES))) -lauto_test
LDTEST_INCLUDES=-Isrc

# Name of main project library

# Find the main source headers
SRC_HEADERS=$(wildcard ../include/*.hpp)

# Find the main source implementation
SRC_IMPLEMENTATION=$(wildcard ../src/*.cpp)

# Source files of the tests present in the `tests/src` folder
TEST_SOURCES=$(wildcard src/*.cpp)
# For multi-level folders add new levels as shown: (yes this is a gross hack, no I'm probably not going to fix this properly for a while)
# TEST_SOURCES+=$(wildcard src/*/*.cpp)
TEST_OBJECTS=$(addprefix obj/, $(patsubst src/%, %, $(TEST_SOURCES:.cpp=.o)))

# Run tests
test: test_build
	make test_build
	./test_build

# Build test program
test_build: $(TEST_OBJECTS) ../lib/lib$(LIB_NAME).a
	$(CC) $(TEST_OBJECTS) $(CCFLAGS) $(LDFLAGS) $(LD_LIBS) $(LDTEST_LIBS) -o $@ 
	
../lib/lib$(LIB_NAME).a: $(SRC_HEADERS) $(SRC_IMPLEMENTATION)
	make -C ../ lib/lib$(LIB_NAME).a

$(TEST_OBJECTS): obj/%.o: src/%.cpp obj/%.dir $(SRC_HEADERS)
	$(CC) $(CCFLAGS) -o $@ -c $< $(LD_INCLUDES) $(LDTEST_INCLUDES)
	
obj/%.dir:
	mkdir -p $@

# Force building of test dependencies
force_build_dependencies: $(INTERNAL_TEST_LIBRARIES)

$(INTERNAL_TEST_LIBRARIES): %:
	make -C $@

clean:
	rm -rf obj
	mkdir obj
	rm -f test_build

OBJ_OUT_DIR=obj
TARGET=out/test_build

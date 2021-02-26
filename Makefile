.PHONY: clean test external_libraries internal_libraries clean_examples examples
CC=g++-10
LDFLAGS=-Wall
CCFLAGS=-Wall -std=c++20 -g

CCFLAGS += -DDEBUG -DASSERTIONS


# For internal projects placed in the `libs` folder
INTERNAL_LIBRARIES=$(wildcard libs/*)
INTERNAL_LIBRARY_INCLUDE_FLAGS=$(addsuffix /include, $(addprefix -I, $(INTERNAL_LIBRARIES)))

# For including external library headers files placed in the `external_libs` folder
EXTERNAL_LIBRARY_INCLUDE_FLAGS=

LDINCLUDES=-Iinclude $(INTERNAL_LIBRARY_INCLUDE_FLAGS) $(EXTERNAL_LIBRARY_INCLUDE_FLAGS)

# For including external library compiled library files placed in the `external_libs` folder
EXTERNAL_LIBS=

LD_LIBS=$(EXTERNAL_LIBS)

.PHONY: $(INTERNAL_LIBRARIES)


# Source files of the project present in `src` folder
PROJECT_SOURCES=$(wildcard src/*.cpp)
# For multi-level folders add new levels as shown: (yes this is a gross hack, no I'm probably not going to fix this properly for a while)
# PROJECT_SOURCES+=$(wildcard src/*/*.cpp)
PROJECT_OBJECTS=$(addprefix obj/, $(patsubst src/%, %, $(PROJECT_SOURCES:.cpp=.o)))

# For projects that generate a library
LIB_NAME=name_here

# For building the 
# For building example programs when creating a libary project
examples: bin/example

bin/example: examples/main.cpp external_libraries $(INTERNAL_LIBRARIES) lib/lib$(LIB_NAME).a
	$(CC) $(CCFLAGS) -o $@ $< $(LDINCLUDES) $(LD_LIBS) -Llib -l$(LIB_NAME)

# For projects that generate a library
lib/lib$(LIB_NAME).a: $(PROJECT_OBJECTS)
	ar ru $@ $^
	ranlib $@


$(PROJECT_OBJECTS): obj/%.o: src/%.cpp include/%.hpp obj/%.dir
	$(CC) $(CCFLAGS) -o $@ -c $< $(LDINCLUDES)

obj/%.dir:
	mkdir -p $@
	
$(INTERNAL_LIBRARIES): %:
	make -C $@

external_libraries:
	make -C external_libs/midifile library

test:
	make -C tests test

clean_examples:
	rm -rf bin
	mkdir bin

clean:
	rm -rf lib
	rm -rf obj
	mkdir lib
	mkdir obj
	make -C tests clean

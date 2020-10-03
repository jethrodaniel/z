# $^ - all of the target's dependency files
# $< - first dependency, $@ is target file
# $< - first dependency, $@ is target file
# $@ - target

PROG=app

CC       := g++
FLAGS    := -std=c++11 -I include
MAIN     := src/main.cpp
MAIN_OBJ := ${MAIN:.cpp=.o}

SRCS    := $(wildcard src/*.cpp)
SRCS    := $(filter-out src/main.cpp, ${SRCS})
HEADERS := $(wildcard include/*.hpp)
OBJS    := ${SRCS:.cpp=.o}
TARGET  := bin

CATCH2_INCLUDE := third_party/Catch2/single_include/catch2
TEST_FLAGS    := -I $(CATCH2_INCLUDE) -I include
TEST_PROG     := test/run
TEST_MAIN     := test/main.cpp
TEST_MAIN_OBJ := ${TEST_MAIN:.cpp=.o}
TEST_SRCS     := $(wildcard test/*test.cpp)
TEST_OBJS     := ${TEST_SRCS:.cpp=.o}

LINT_FLAGS := -checks='*' -header-filter='.*'

##

default: clean test run

##
# Helpers
tree:
	tree -I third_party

##
# Cleanup object files and executables.
# To avoid compiling Catch2, we don't remove the test driver obj file.
clean:
	rm -rfv *.o $(TEST_OBJS) $(TEST_PROG) $(OBJS) $(MAIN_OBJ) $(TARGET)
purge: clean
	rm -rf $(TEST_MAIN_OBJ)

##
# Create executable
#
run: $(TARGET)/$(PROG)
	./$<
$(TARGET):
	mkdir -p $(TARGET)
$(OBJS): $(SRCS)
	$(CC) $(FLAGS) $< -o $@ -c
$(TARGET)/$(PROG): $(OBJS) $(MAIN)
	mkdir -p $(TARGET)
	$(CC) $(FLAGS) $^ -o $@

##
# Testing using Catch2
#
# We first compile Catch's test driver, then we link our specs against
# it. We do this to prevent having to recompile Catch2 every time we
# need to recompile our tests.
#
# See https://github.com/catchorg/Catch2/blob/master/docs/slow-compiles.md
#
test: $(TEST_PROG)
	./$<
$(TEST_OBJS): $(TEST_SRCS)
	$(CC) $(FLAGS) $(TEST_FLAGS) $^ -o $@ -c
$(TEST_MAIN_OBJ):
	$(CC) $(FLAGS) $(TEST_FLAGS) $(TEST_MAIN) -c -o $@
$(TEST_PROG): $(OBJS) $(TEST_OBJS) $(TEST_MAIN_OBJ)
	$(CC) $(FLAGS) $(TEST_FLAGS) $^ -o $@

##
# Lint
lint: $(SRCS) $(TEST_SRCS) $(MAIN)
	clang-tidy $(LINT_FLAGS) $^ -- -I $(CATCH2_INCLUDE) $(FLAGS)
fix: $(SRCS) $(TEST_SRCS) $(MAIN)
	clang-tidy --fix $(LINT_FLAGS) $^ -- -I $(CATCH2_INCLUDE) $(FLAGS)

##
# Install prerequisites
prereqs:
	yum install -y centos-release-scl llvm-toolset-7-clang-tools-extra
	scl enable llvm-toolset-7 bash

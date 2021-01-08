WARNINGS = -Werror -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter

# gcc flags used for both debug and opt builds
BASE_CXX_FLAGS := -MD $(CXXFLAGS) $(WARNINGS) -std=c++11

# Debug flags
CXXFLAGS = -g $(BASE_CXX_FLAGS)
# Optimization flags
#CXXFLAGS = -g -O3 -DNDEBUG $(BASE_CXX_FLAGS)

# Link with the C++ standard library
LDFLAGS=-lstdc++

BINARIES = btree_test randomgenerator_test tpccclient_test tpcctables_test tpccgenerator_test tpcc
OBJFILES = $(BINARIES:%=%.o)

#all: $(BINARIES)
all: $(OBJFILES) $(BINARIES)

# generalized objfiles rule
%.o: %.cc
	$(CXX) $(CXXFLAGS) -c $? -o $@

# binaries with their dependencies listed
btree_test: btree_test.o stupidunit.o
	$(CXX) $(LDFLAGS) $? -o $@
randomgenerator_test: randomgenerator_test.o randomgenerator.o stupidunit.o
	$(CXX) $(LDFLAGS) $? -o $@
tpccclient_test: tpccclient_test.o tpccclient.o randomgenerator.o stupidunit.o
	$(CXX) $(LDFLAGS) $? -o $@
tpcctables_test: tpcctables_test.o tpcctables.o tpccdb.o randomgenerator.o stupidunit.o
	$(CXX) $(LDFLAGS) $? -o $@
tpccgenerator_test: tpccgenerator_test.o tpccgenerator.o tpcctables.o tpccdb.o randomgenerator.o stupidunit.o
	$(CXX) $(LDFLAGS) $? -o $@
tpcc: tpcc.o tpccclient.o tpccgenerator.o tpcctables.o tpccdb.o clock.o randomgenerator.o stupidunit.o
	$(CXX) $(LDFLAGS) $? -o $@

clean :
	$(RM) *.o *.d $(BINARIES)

-include *.d

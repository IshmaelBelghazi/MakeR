##################################################
# MakeR 0.2.0                                    #
# -----------                                    #
# Author: Mohamed Ishmael Diwan Belghazi (2015)  #
# Email:  ishmael.belghazi@gmail.com             #
# ################################################
#                                                #
# Usage:                                         #
# ------                                         #
# See README                                     #
# ################################################
###############################
## R configuration Variables ##
###############################
##,---------------
##| R build helper
##`---------------
RC=R --vanilla CMD SHLIB
R_COMMAND=R --no-save --slave
##,-----------------------------------
##| Defining R config Fetcher function
##`-----------------------------------
R_CONF=R --vanilla CMD config
R_getconf=$(shell $(R_CONF) $(1))
###############################
## C Configuration variables ##
###############################
##,----------------------------a
##| Getting pre-processor flags
##`----------------------------
R_INCLUDE_FLAG=$(call R_getconf, --cppflags)
##,---------------------
##| Getting Linker Flags
##`---------------------
R_LDFLAGS=$(call R_getconf, --ldflags)
##,-------------------------
##| Getting C compiler flags
##`-------------------------
CC=$(call R_getconf, CC)
CFLAGS=$(call R_getconf, CFLAGS)
CPICFLAGS=$(call R_getconf, CPICFLAGS)
C_SYS_INCLUDE_PATH?=/usr/local/include
##,-----------------------
##| Getting C linker flags
##`-----------------------
DYLIB_EXT=$(call R_getconf, DYLIB_EXT)
DYLIB_LD=$(call R_getconf, DYLIB_LD)
LDFLAGS=$(call R_getconf, LDFLAGS)
##,-------------------------------
##| Getting C shared objects flags
##`-------------------------------
SHLIB_EXT=$(call R_getconf, SHLIB_EXT)
SHLIB_LD=$(call R_getconf, SHLIB_LD)
SHLIB_LDFLAGS=$(call R_getconf, SHLIB_LDFLAGS)
SHLIB_CFLAGS=$(call R_getconf, SHLIB_CFLAGS)
#################################
## C++ configuration variables ##
#################################
## TODO(Ishmael): Add C++ configuration variables
#####################################
## FORTRAN configuration variables ##
#####################################
## TODO(Ishmael): Add FORTRAN configuration variables
##################################
## JAVA configuration variables ##
##################################
## TODO(Ishmael): Add FORTRAN configuration variables
##################################
## CUDA configuration variables ##
##################################
## TODO(Ishmael): Add CUDA configuration variables
#######################################
## Libraries configuration Variables ##
#######################################
##,-------------------
##| Getting BLAS flags
##`-------------------
BLAS_LIBS=$(call R_getconf, BLAS_LIBS)
##,---------------------
##| Getting LAPACK flags
##`---------------------
LAPACK_LIBS=$(call R_getconf, LAPACK_LIBS)
#########################
## miscellaneous flags ##
#########################
##,------------------
##| Source files path
##`------------------
## ./src by default
SRC_PATH?=./src
#############
## C Build ##
#############
##,--------------------------------------------
##| Defining Sources, Dependencies, and Targets
##`--------------------------------------------
SOURCES?=$(wildcard $(SRC_PATH)/*.c)
OBJECTS=$(SOURCES:.c=.o)
TARGETS?=$(SOURCES:.c=$(SHLIB_EXT))
## * Defining Makefile
## ** Build processes
## Defining Build
all: build
build: $(TARGETS)
rebuild: veryclean build
$(TARGETS): $(OBJECTS)
	@printf "%s\n" "Linking ..."
	$(SHLIB_LD) $(SHLIB_LDFLAGS) $(LDFLAGS) $^ -o $@ $(R_LDFLAGS) $(BLAS_LIBS)
	@printf "%s\n" "... Linking completed."
##$(OBJECTS): $(SOURCES)
%.o: %.c
	@printf "%s\n" "Compiling ..."
	$(CC) $(R_INCLUDE_FLAG) -DNDEBUG -I$(C_SYS_INCLUDE_PATH) $(CPICFLAGS) $(CFLAGS) -c $< -o $@
	@printf "%s\n" "... Compilation completed."
#######################################
## Environement variables diagnostic ##
#######################################
diagnostic:
	@printf '%s\n' "####################################"
	@printf '%s\n' "## R config environment variables ##"
	@printf '%s\n' "####################################"
	@printf '%s\n' "R configuration exec:"
	@printf '%s\n' "$(R_CONF)"
	@printf '%s\n' "R shared lib helper script:"
	@printf '%s\n' "$(RC)"
	@printf '%s\n' "R C shared lib compilation preprocessor flags:"
	@printf '%s\n' "$(R_INCLUDE_FLAG)"
	@printf '%s\n' "R C shared lib linking flags:"
	@printf '%s\n' "$(R_LDFLAGS)"
	@printf '%s\n' "################################################"
	@printf '%s\n' "## C compilation config environment variables ##"
	@printf '%s\n' "################################################"
	@printf '%s\n' "C compiler:"
	@printf '%s\n' "$(CC)"
	@printf '%s\n' "C compiler additional flags:"
	@printf '%s\n' "$(CFLAGS)"
	@printf '%s\n' "C compiler shared libs compilation flags:"
	@printf '%s\n' "$(CPICFLAGS)"
	@printf '%s\n' "C system include path:"
	@printf '%s\n' "$(C_SYS_INCLUDE_PATH)"
	@printf '%s\n' "##############################################################"
	@printf '%s\n' "## C dynamically loaded modules config environment variables #"
	@printf '%s\n' "##############################################################"
	@printf '%s\n' "Dynamically loaded modules system extension:"
	@printf '%s\n' "$(DYLIB_EXT)"
	@printf '%s\n' "Dynamically loaded modules library path:"
	@printf '%s\n' "$(DYLIB_LD)"
	@printf '%s\n' "Dynamically loaded modules additional flags:"
	@printf '%s\n' "$(LDFLAGS)"
	@printf '%s\n' "#####################################################"
	@printf '%s\n' "## C shared libraries config environment variables ##"
	@printf '%s\n' "#####################################################"
	@printf '%s\n' "Shared libraries system extension:"
	@printf '%s\n' "$(SHLIB_EXT)"
	@printf '%s\n' "Shared libraries library include directory:"
	@printf '%s\n' "$(SHLIB_LD)"
	@printf '%s\n' "Shared libraries library additional flags:"
	@printf '%s\n' "$(SHLIB_LDFLAGS)"
	@printf '%s\n' "Shared libraries C flags"
	@printf '%s\n' "$(SHLIB_CFLAGS)"
	@printf '%s\n' "##############################################"
	@printf '%s\n' "## BLAS/LAPACK config environment variables ##"
	@printf '%s\n' "##############################################"
	@printf '%s\n' "BLAS library configuration:"
	@printf '%s\n' "$(BLAS_LIBS)"
	@printf '%s\n' "$(LAPACK_LIBS)"
##############
## Cleaning ##
##############
clean:
	rm -f $(SRC_PATH)/*.o
veryclean: clean
	rm -f $(SRC_PATH)/*$(SHLIB_EXT)
##############
## Building ##
##############
build/R:
	@echo "devtools::build()" | $(R_COMMAND)
rebuild/R: veryclean build/R
reload:
	@echo "devtools::reload()" | $(R_COMMAND)
###################
## Documentation ##
###################
document:
	@echo "devtools::document()" | $(R_COMMAND)
build/vignette:
	@echo "devtools::build_vignettes()" | $(R_COMMAND)
###########
## Tests ##
###########
test/custom:
	@printf "%s\n" "Running test..."
	@chmod +x ./test_custom
	@./test_custom
	@printf "%s\n" "... Test finished."
test/fast:
	@echo "devtools::test()" | $(R_COMMAND)
test: veryclean reload document test/fast
test/all: test test/custom
############
## Checks ##
############
check/docs: document
	@echo "devtools::check_doc()" | $(R_COMMAND)
check/examples: document
	@echo "devtools::run_examples()" | $(R_COMMAND)
check/cran:
	@echo "devtools::check(check_dir='./checks/, cran=TRUE')" | $(R_COMMAND)
check:
	@echo "devtools::check(check_dir='./checks/')" | $(R_COMMAND)
###############
## Debugging ##
###############
valgrind:
	@R -d valgrind --vanilla < test_custom
cudamemcheck:
	@cuda-memcheck ./test_custom
###################
## Code Coverage ##
###################
coverage:
	@echo "library(covr);cov <- package_coverage();shine(cov)" | $(R_COMMAND)
#############
## Linting ##
#############
##,-------
##| R lint
##`-------
lint/R:
	@echo "devtools::lint()"
##,-------
##| C lint
##`-------
## TODO(Ishmael): Add C code linters.
infer: veryclean
	@infer -- make
###############
## Benchmark ##
###############
benchmark:
	@./inst/benchmarks/run_bench
#####################################
## Compilation database generation ##
#####################################
## Generates Json compilation database using bear.
compdb/fast:
	@bear -o $(SRC_PATH)/compile_commands.json make build
compdb: veryclean compdb/fast veryclean
#################
## Misc config ##
#################
.PHONY: all diagnostic clean veryclean build build/R rebuild reload document
	build/vignette test/custom test/fast test test/all check/docs
	check/examples check/cran check valgrind cudamemcheck
	coverage lint/R benchmark compdb/fast compdb

#------------------------------------------------------------------------------#

PROGRAM := "App"

#------------------------------------------------------------------------------#

.PHONY: all debug build build-release run migrate revert clean clean-all test

all: build

build:
	@ swift build

build-release:
	@ swift build --configuration release

run:
	@ swift run $(PROGRAM) --auto-migrate

migrate:
	@ swift run $(PROGRAM) migrate --auto-migrate

revert:
	@ swift run $(PROGRAM) migrate --auto-revert

routes:
	@ swift run $(PROGRAM) routes

clean:
	@- echo "Cleaning packages.." ; \
		swift package clean

clean-all:
	@- echo "Cleaning project.." ; \
		rm -rf ./.build

test:
	@ swift test

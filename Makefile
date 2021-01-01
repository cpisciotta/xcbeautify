PRODUCT_NAME=xcbeautify
VERSION=$(version)

PREFIX?=/usr/local

CD=cd
CP=$(shell whereis cp) -Rf
GIT=$(shell which git)
HUB=$(shell which hub)
MKDIR=$(shell which mkdir) -p
RM=$(shell whereis rm) -rf
SED=/usr/bin/sed
SWIFT=$(shell which swift)
ZIP=$(shell whereis zip) -r

SHARED_SWIFT_BUILD_FLAGS = --configuration release --disable-sandbox

TARGET_PLATFORM=universal-apple-macosx
PACKAGE_ZIP="$(PRODUCT_NAME)-$(VERSION)-$(TARGET_PLATFORM).zip"

BINARY_DIRECTORY=$(PREFIX)/bin
BUILD_DIRECTORY=$(shell swift build --show-bin-path $(SHARED_SWIFT_BUILD_FLAGS))
OUTPUT_EXECUTABLE=$(BUILD_DIRECTORY)/$(PRODUCT_NAME)
INSTALL_EXECUTABLE_PATH=$(BINARY_DIRECTORY)/$(PRODUCT_NAME)

USE_SWIFT_VERSION_4:=$(shell swift -version | grep '.*Swift version 4.*' > /dev/null && echo yes)
ifeq ($(USE_SWIFT_VERSION_4), yes)
# Link Swift stdlib statically
SWIFT_BUILD_FLAGS += --static-swift-stdlib
# Swift 4 uses a different build directory
TARGET_PLATFORM=x86_64-apple-macosx10.10
endif

.PHONY: all
all: build

.PHONY: test
test: clean
	$(SWIFT) test

# Disable sandbox since SwiftPM needs to access to the internet to fetch dependencies
.PHONY: build
build:
	$(SWIFT) build $(SHARED_SWIFT_BUILD_FLAGS)

.PHONY: package-darwin-x86_64
package-darwin-x86_64:
	$(eval TARGET_TRIPLE := x86_64-apple-macosx)
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --triple $(TARGET_TRIPLE))
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PRODUCT_NAME).zip" "$(PRODUCT_NAME)"

.PHONY: package-darwin-arm64
package-darwin-arm64:
	$(eval TARGET_TRIPLE := arm64-apple-macosx)
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --triple $(TARGET_TRIPLE))
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PRODUCT_NAME).zip" "$(PRODUCT_NAME)"

.PHONY: package-darwin-universal
package-darwin-universal:
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --arch x86_64 --arch arm64)
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PRODUCT_NAME).zip" "$(PRODUCT_NAME)"

.PHONY: package-linux-x86_64
package-linux-x86_64:
	$(eval TARGET_TRIPLE := x86_64-unknown-linux-gnu)
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --triple $(TARGET_TRIPLE))
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	docker run --rm --volume `pwd`:/workdir --workdir /workdir \
		swift:5.3.2-bionic swift build $(SWIFT_BUILD_FLAGS)
	tar --cd "$(BUILD_DIRECTORY)" --create --xz --file \
		"$(BUILD_DIRECTORY)/$(PRODUCT_NAME).tar.xz" "$(PRODUCT_NAME)"

.PHONY: install
install: build
	$(MKDIR) $(BINARY_DIRECTORY)
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: package
package: bump-version package-darwin-universal package-darwin-x86_64 package-darwin-arm64 package-linux-x86_64

.PHONY: bump-version
bump-version:
	$(SED) -i '' '1s/.*/let version = "$(VERSION)"/' Sources/xcbeautify/Version.swift
	$(SED) -i '' "3s/.*/  s.version        = '$(VERSION)'/" xcbeautify.podspec

.PHONY: release
release: bump-version
	$(GIT) commit Sources xcbeautify.podspec -m "Release version $(VERSION)"
	$(GIT) push origin master
	$(GIT) tag $(VERSION)
	$(GIT) push origin $(VERSION)

.PHONY: xcode
xcode:
	$(SWIFT) package generate-xcodeproj

.PHONY: uninstall
uninstall:
	$(RM) "$(BINARY_DIRECTORY)/$(PRODUCT_NAME)"

.PHONY: clean
clean:
	$(SWIFT) package clean

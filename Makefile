PRODUCT_NAME=xcbeautify
VERSION=$(version)

PREFIX?=/usr/local

CD=cd
CP=$(shell whereis cp) -Rf
GIT=$(shell which git)
RM=$(shell whereis rm) -rf
SED=$(shell which sed)
SWIFT=$(shell which swift)
ZIP=$(shell whereis zip) -r

TARGET_PLATFORM=x86_64-apple-macosx10.10
PACKAGE_ZIP="$(PRODUCT_NAME)-$(VERSION)-$(TARGET_PLATFORM).zip"

BINARY_DIRECTORY=$(PREFIX)/bin
BUILD_DIRECTORY=$(shell pwd)/.build/$(TARGET_PLATFORM)/release
OUTPUT_EXECUTABLE=$(BUILD_DIRECTORY)/$(PRODUCT_NAME)
INSTALL_EXECUTABLE_PATH=$(BINARY_DIRECTORY)/$(PRODUCT_NAME)

.PHONY: all
all: build

.PHONY: test
test: clean
	$(SWIFT) test

.PHONY: build
build:
	$(SWIFT) build -c release -Xswiftc -static-stdlib

.PHONY: install
install: build
	$(CP) "$(OUTPUT_EXECUTABLE)" "$(BINARY_DIRECTORY)"

.PHONY: package
package: bump-version build
	$(CD) "$(BUILD_DIRECTORY)" && $(ZIP) "$(PACKAGE_ZIP)" "$(PRODUCT_NAME)"
	$(CP) "$(BUILD_DIRECTORY)/$(PACKAGE_ZIP)" "$(PACKAGE_ZIP)"

.PHONY: bump-version
bump-version:
	$(SED) -i '' '4s/.*/  version "$(VERSION)"/' Formula/xcbeautify.rb
	$(SED) -i '' '1s/.*/let version = "$(VERSION)"/' Sources/xcbeautify/Version.swift

.PHONY: release
release: clean package
	$(SED) -i '' '6s/.*/  sha256 "$(shell shasum -a 256 "$(PACKAGE_ZIP)" | cut -f 1 -d " ")"/' Formula/xcbeautify.rb
	$(GIT) commit Formula Sources -m "Release version $(VERSION)"
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

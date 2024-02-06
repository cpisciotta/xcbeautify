PRODUCT_NAME=xcbeautify
VERSION=$(version)

PREFIX?=/usr/local

CD=cd
CP=/bin/cp -Rf
GIT=/usr/bin/git
MKDIR=/bin/mkdir -p
RM=/bin/rm -rf
SED=/usr/bin/sed
SWIFT=/usr/bin/swift
ZIP=/usr/bin/zip -r

SHARED_SWIFT_BUILD_FLAGS = --configuration release --disable-sandbox

TARGET_PLATFORM=universal-apple-macosx
PACKAGE_ZIP="$(PRODUCT_NAME)-$(VERSION)-$(TARGET_PLATFORM).zip"

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
		swift:5.9 swift build $(SWIFT_BUILD_FLAGS)
	tar --directory "$(BUILD_DIRECTORY)" --create --xz --file \
		"$(PRODUCT_NAME).tar.xz" "$(PRODUCT_NAME)"

.PHONY: install-swift
install-swift:
	tools/install-swift-linux-arm64

# This has to run directly on Linux arm64 for now, because GitHub Actions'
# Ubuntu has problems running the arm64v8/ubuntu Docker image
.PHONY: package-linux-arm64
package-linux-arm64: install-swift
	$(eval TARGET_TRIPLE := aarch64-unknown-linux-gnu)
	$(eval SWIFT_BUILD_FLAGS := $(SHARED_SWIFT_BUILD_FLAGS) --triple $(TARGET_TRIPLE))
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SWIFT_BUILD_FLAGS)))
	swift build $(SWIFT_BUILD_FLAGS)
	tar --directory "$(BUILD_DIRECTORY)" --create --xz --file \
		"$(PRODUCT_NAME).tar.xz" "$(PRODUCT_NAME)"

.PHONY: install
install: build
	$(eval BINARY_DIRECTORY := $(PREFIX)/bin)
	$(eval BUILD_DIRECTORY := $(shell swift build --show-bin-path $(SHARED_SWIFT_BUILD_FLAGS)))
	$(MKDIR) $(BINARY_DIRECTORY)
	$(CP) "$(BUILD_DIRECTORY)/$(PRODUCT_NAME)" "$(BINARY_DIRECTORY)"

.PHONY: package
package: package-darwin-universal package-darwin-x86_64 package-darwin-arm64

.PHONY: release
release:
	$(SED) -i '' '1s/.*/let version = "$(VERSION)"/' Sources/xcbeautify/Version.swift
	$(GIT) add Sources/xcbeautify/Version.swift
	$(GIT) commit -m "Bump version to $(VERSION)"
	$(GIT) push origin main
	$(GIT) tag $(VERSION)
	$(GIT) push origin $(VERSION)

.PHONY: uninstall
uninstall:
	$(RM) "$(BINARY_DIRECTORY)/$(PRODUCT_NAME)"

.PHONY: clean
clean:
	$(SWIFT) package clean

.PHONY: format
format:
	tools/format

.PHONY: lint
lint:
	tools/lint

.PHONY: coverage
export_coverage:
	tools/export_coverage

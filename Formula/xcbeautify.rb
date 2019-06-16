class Xcbeautify < Formula
  desc "A little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  version "0.4.2"
  url "https://github.com/thii/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx.zip"
  sha256 "bf2f25a84b63bf0e9a7a6deb891506714aebbea13a46ddb4dfeaeb10022fc248"
  head "https://github.com/thii/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

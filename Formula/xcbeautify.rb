class Xcbeautify < Formula
  desc "A little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  version "0.2.1"
  url "https://github.com/thii/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx10.10.zip"
  sha256 "4cec27fdbf540d4ff8a073ae02f9c0550562fda2e74193776589d1fc8bd8f963"
  head "https://github.com/thii/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

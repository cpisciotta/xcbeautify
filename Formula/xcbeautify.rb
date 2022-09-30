class Xcbeautify < Formula
  desc "A little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  version "0.8.1"
  url "https://github.com/tuist/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx.zip"
  sha256 "75e9d345a68a759ab268f0ecef4373a0ae590b07939096a076bdb25f20e69143"
  head "https://github.com/tuist/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

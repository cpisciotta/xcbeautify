class Xcbeautify < Formula
  desc "A little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  version "0.7.6"
  url "https://github.com/thii/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx.zip"
  sha256 "0d0da527f22b7b1b107a2d413b10013ea0f5cc6de0aefc4596102e8e7770c7e5"
  head "https://github.com/thii/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

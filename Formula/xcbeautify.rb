class Xcbeautify < Formula
  desc "A little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  version "0.4.0"
  url "https://github.com/thii/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx10.14.zip"
  sha256 "ee08f514b98651a19f105128a7af7888b843892200fe93edf7da85b05ee34a8c"
  head "https://github.com/thii/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

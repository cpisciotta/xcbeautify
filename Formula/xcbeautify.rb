class Xcbeautify < Formula
  desc "A little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  version "0.3.7"
  url "https://github.com/thii/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx10.10.zip"
  sha256 "a0ecda0f3e0f99ad0a7ef7244a981a77f44e5092739c932a91bb36b282299658"
  head "https://github.com/thii/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

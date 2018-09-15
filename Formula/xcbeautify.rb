class Xcbeautify < Formula
  version = "0.2.0"
  homepage "https://github.com/thii/xcbeautify"
  version "0.1.0"
  url "https://github.com/thii/xcbeautify/releases/download/#{version}/xcbeautify-#{version}-x86_64-apple-macosx10.10.zip"
  sha256 "53f6395f86aab6814a461fe1e9bfc7b23bf8cf44fdafd45a9f3503bdaece914e"
  head "https://github.com/thii/xcbeautify.git"

  def install
    bin.install "xcbeautify"
  end

  test do
    system bin/"xcbeautify", "--version"
  end
end

class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.21.tar.gz"
  sha256 "9b30f4257ef0f0806dea5a27c9ad8edc3f7999f05ddaff6f0627064dc927e615"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?colordiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5a83886f7e7aacfc46cc6a759f91dd8b80a068cf0bb6b4fa4815c4b310ecefd8"
  end

  depends_on "coreutils" => :build # GNU install

  def install
    man1.mkpath
    system "make", "INSTALL=ginstall",
                   "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp OSPACK_PREFIX+"bin/ospack", "ospack1"
    cp OSPACK_PREFIX+"bin/ospack", "ospack2"
    system bin/"colordiff", "ospack1", "ospack2"
  end
end

class Tre < Formula
  desc "Lightweight, POSIX-compliant regular expression (regex) library"
  homepage "https://laurikari.net/tre/"
  url "https://laurikari.net/tre/tre-0.8.0.tar.bz2"
  sha256 "8dc642c2cde02b2dac6802cdbe2cda201daf79c4ebcbb3ea133915edf1636658"
  license "BSD-2-Clause"

  livecheck do
    url "https://laurikari.net/tre/download/"
    regex(/href=.*?tre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "65e18fa2b212d3a257575084556b5aee964bcab0003f66023cf774c1959d1bce"
    sha256 cellar: :any, arm64_sonoma:   "64a1c4bef03e0dc1bf980df8e24a418748e7bfe1824cc170e54fcc0154f2fe5f"
    sha256 cellar: :any, arm64_ventura:  "947292c07cddb27803a651f80bdebd4af83062cfaa7a267d5bdf04c27930333c"
    sha256 cellar: :any, arm64_monterey: "eed6c3c934fdeb27988331fe31137cd3849a46c877ff05e614f544e140ff9ab8"
    sha256 cellar: :any, arm64_big_sur:  "70e4b1149b1e72f6f86634dca2814241bddc8b5239cc243dd27ff7cfe669680e"
    sha256 cellar: :any, sonoma:         "453306497febbca94d5c057f498a012c714be112b44ccc2871f02a2ca99daea6"
    sha256 cellar: :any, ventura:        "190267705d135967a226e3f5049bae0be2b74529debd821ca970653d57515b70"
    sha256 cellar: :any, monterey:       "f2f8c94e26b27a1e3e1dcc8d99fa375ade859cc85ee1b53a7a02c8f79137f721"
    sha256 cellar: :any, big_sur:        "112a8c8590e654fbbbd5339cf5b3fa83a5c163c3320fcb386ddc0affad7148b2"
    sha256 cellar: :any, catalina:       "26b187538786109c8a08f52cb868ea9cf70dfbc9681c014a4778ead61c90f389"
    sha256 cellar: :any, mojave:         "6135ceb88c62b006fb0fbcc772ffd4006da4ae03d05fd872155fa36d33216efc"
    sha256 cellar: :any, high_sierra:    "eaab931989b5bf5fc18949eaa234a1840531ef3aeb9deda65e4d66be40cae149"
    sha256 cellar: :any, sierra:         "e28b7ac6153b06c067538f555f9ac5973df49c14ac2693aa4239ae407982e2c9"
    sha256 cellar: :any, el_capitan:     "8a1762dbd40b98869e01a19c29cdb1cfa5a127543b3e132fb0fdff996e46f566"
    sha256               x86_64_linux:   "1b8c9e6644e085500532d787b850f351032b8bb1f583dca9397d533c27e75a9b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "brow", pipe_output("#{bin}/agrep -1 ospack", "brow", 0)
  end
end

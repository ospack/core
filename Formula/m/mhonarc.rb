class Mhonarc < Formula
  desc "Mail-to-HTML converter"
  homepage "https://www.mhonarc.org/"
  url "https://www.mhonarc.org/release/MHonArc/tar/MHonArc-2.6.19.tar.bz2"
  sha256 "08912eae8323997b940b94817c83149d2ee3ed11d44f29b3ef4ed2a39de7f480"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url :homepage
    regex(/href=.*?MHonArc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4d56bb7e4a40a68b0a23faf8d4df159142e6e4f1f55ebd457fffd64e478a6d9"
  end

  depends_on "perl"

  # Apply a bugfix for syntax. https://savannah.nongnu.org/bugs/?49997
  patch do
    url "https://file.savannah.gnu.org/file/monharc.patch?file_id=39391"
    sha256 "723ef1779474c6728fbc88b1f6e9a4ca2c22d76a8adc4d3bd8838793852e60c4"
  end

  def install
    # Using Perl's `installprefix` rather than `prefix` allows install.me to use
    # Ospack Perl directory structure even if the prefixes are different paths.
    inreplace "install.me", "$Config{'prefix'}", "$Config{'installprefix'}"

    system "perl", "install.me",
           "-batch",
           "-perl", Formula["perl"].opt_bin/"perl",
           "-prefix", prefix

    bin.install "mhonarc"
  end

  test do
    system bin/"mhonarc", "-v"
  end
end

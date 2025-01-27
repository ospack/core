class Phpospack < Formula
  desc "Ospack & manage PHP versions in pure PHP at HOME"
  homepage "https://phpospack.github.io/phpospack"
  url "https://github.com/phpospack/phpospack/releases/download/2.2.0/phpospack.phar"
  sha256 "3247b8438888827d068542b2891392e3beffebe122f4955251fa4f9efa0da03d"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5313331a47dc3d43289333b1a1345dd53fcfd6b1cff99db2ee2483302288b1d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5313331a47dc3d43289333b1a1345dd53fcfd6b1cff99db2ee2483302288b1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5313331a47dc3d43289333b1a1345dd53fcfd6b1cff99db2ee2483302288b1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5313331a47dc3d43289333b1a1345dd53fcfd6b1cff99db2ee2483302288b1d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "593e3afb0ab7517aba5f5576cb14b11ef5c1f58de3d6707688d1d6a751835b3f"
    sha256 cellar: :any_skip_relocation, ventura:        "593e3afb0ab7517aba5f5576cb14b11ef5c1f58de3d6707688d1d6a751835b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "593e3afb0ab7517aba5f5576cb14b11ef5c1f58de3d6707688d1d6a751835b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5313331a47dc3d43289333b1a1345dd53fcfd6b1cff99db2ee2483302288b1d8"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpospack.phar" => "phpospack"
  end

  test do
    system bin/"phpospack", "init"
    assert_match "8.0", shell_output("#{bin}/phpospack known")
  end
end

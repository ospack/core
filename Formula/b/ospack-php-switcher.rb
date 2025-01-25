class OspackPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/ospack-php-switcher"
  url "https://github.com/philcook/ospack-php-switcher/archive/refs/tags/v2.6.tar.gz"
  sha256 "a1d679b9d63d2a7b1e382c1e923bcb1aa717cee9fe605b0aaa70bb778fe99518"
  license "MIT"
  head "https://github.com/philcook/ospack-php-switcher.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e41fbf1a76ac7c925c36ece1c26a597245e89a4c9444b3a145a1e6c054042dc0"
  end

  depends_on "php" => :test

  def install
    bin.install "phpswitch.sh"
    bin.install_symlink "phpswitch.sh" => "ospack-php-switcher"
  end

  test do
    assert_match "usage: ospack-php-switcher version",
                 shell_output(bin/"ospack-php-switcher")
  end
end

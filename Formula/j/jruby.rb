class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.10.0/jruby-dist-9.4.10.0-bin.tar.gz"
  sha256 "0b325bb6e64896dfcf235bbc6506ca9b5af78f1c8fec7f048bc4188b1793b5e0"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f3330a7e9413afa5ad1677fc5c68bd1803b5d976a3fa5f88f30942943bbe4e6"
    sha256 cellar: :any,                 arm64_sonoma:  "3f3330a7e9413afa5ad1677fc5c68bd1803b5d976a3fa5f88f30942943bbe4e6"
    sha256 cellar: :any,                 arm64_ventura: "3f3330a7e9413afa5ad1677fc5c68bd1803b5d976a3fa5f88f30942943bbe4e6"
    sha256 cellar: :any,                 sonoma:        "bc13189a0f27d4b0f7eb1ee9ce856a247181d594ac4c2a6fdd3827b281c4897b"
    sha256 cellar: :any,                 ventura:       "bc13189a0f27d4b0f7eb1ee9ce856a247181d594ac4c2a6fdd3827b281c4897b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7797250814f6d55c9a6378b802c46eec34e3b24d4d342d10b0ca62b185ab8ef"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast erb bundle bundler rake rdoc ri racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_r(Dir["lib/jni/*"] - ["lib/jni/Darwin"])
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible libfixposix library
    os = OS.kernel_name.downcase
    if OS.linux?
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    end
    libfixposix_binary = libexec/"lib/ruby/stdlib/libfixposix/binary"
    libfixposix_binary.children
                      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
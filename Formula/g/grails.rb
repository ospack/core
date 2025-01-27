class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v6.2.3/grails-6.2.3.zip"
  sha256 "b41e95efad66e2b93b4e26664f746a409ea70d43548e6c011e9695874a710b09"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d99581afd8f11f9c5064cc312865fc0d6fe2ec04a20035c02f47add859c2ae8"
    sha256 cellar: :any_skip_relocation, ventura:       "6d99581afd8f11f9c5064cc312865fc0d6fe2ec04a20035c02f47add859c2ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
  end

  depends_on "openjdk@17"

  resource "cli" do
    url "https://github.com/grails/grails-forge/releases/download/v6.2.3/grails-cli-6.2.3.zip"
    sha256 "ef78a48238629a89d64996367d0424bc872978caf6c23c3cdae92b106e2b1731"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "cli resource needs to be updated" if version != resource("cli").version

    libexec.install Dir["*"]

    resource("cli").stage do
      rm("bin/grails.bat")
      (libexec/"lib").install Dir["lib/*.jar"]
      bin.install "bin/grails"
      bash_completion.install "bin/grails_completion" => "grails"
    end

    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("17")
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"grails", "create-app", "ospack-test"
    assert_predicate testpath/"ospack-test/gradle.properties", :exist?
    assert_match "ospack.test", File.read(testpath/"ospack-test/build.gradle")

    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails --version")
  end
end
class Tach < Formula
  include Language::Python::Virtualenv

  desc "Tool to enforce dependencies using modular architecture"
  homepage "https://docs.gauge.sh/getting-started/introduction"
  url "https://files.pythonhosted.org/packages/d9/4b/de2e7ad0a22e63fbed979064381da1290391dd623a3fd80d0728ea72d545/tach-0.23.0.tar.gz"
  sha256 "ae123491231ab0712417d579b9a3259014d713d72626805ff64552955e43e912"
  license "MIT"
  head "https://github.com/gauge-sh/tach.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dc450c4441debb8d3358b786086583f865a8ef46c6e05b54de759c1993c6896"
    sha256 cellar: :any,                 arm64_sonoma:  "8ac4a6a43f71d228bd72680176d56125d672db150df57d48e80f65b43a2f88d5"
    sha256 cellar: :any,                 arm64_ventura: "5911b4ca10b7bb8b2ea798b29c307e25f1669b89cdccdb9fb1ff34b03a33efe0"
    sha256 cellar: :any,                 sonoma:        "0d6083324e08ddb350f052d8fe0349df174a4f655c74463593f535059874c8f0"
    sha256 cellar: :any,                 ventura:       "fbb07616d97c04385f3584926b141422fe13ecfab37dc935a85e52ef5386fae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9555581324b1c85e1875c9d71655e61e477f3b7caa3f32853d85d0baad1ee835"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/e1/bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854/prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/66/dd/e0e6a4fb84c22050f6a9701ad9fd6a67ef82faa7ba97b97eb6fdc6b49b34/pydot-3.0.4.tar.gz"
    sha256 "3ce88b2558f3808b0376f22bfa6c263909e1c3981e2a7b629b65b451eee4a25d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/18/87/302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4ff/tomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tach --version")

    assert_match "tach.toml not found", shell_output("#{bin}/tach server 2>&1", 1)
  end
end
class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https://cloudsplaining.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6e/09/acb8e088d1c6cc6fc9d6d42c1e61168f36339f13b1ea8e54f9a7e93949d1/cloudsplaining-0.8.0.tar.gz"
  sha256 "02029432316a56551e58296496bc80e4778a58468273dbcd61df4ed2c369ede4"
  license "BSD-3-Clause"
  head "https://github.com/salesforce/cloudsplaining.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b6d005097d941d05f58342fa112cf112c96ef56b1315e65af0491bf4c579b6b"
    sha256 cellar: :any,                 arm64_sonoma:  "e4d43bf8c1315747e948bc6790e0d2ad4b6abbc8939b594409533411fc3b6923"
    sha256 cellar: :any,                 arm64_ventura: "88e4d6e745ace4b7642d74ff2314f9a440fe5bfcbde3cdf76f236b260406a504"
    sha256 cellar: :any,                 sonoma:        "976c64c751cf51e91f0a7d680918f46a2a7747ca2e2bb6a1120171c09f0e3b30"
    sha256 cellar: :any,                 ventura:       "4423eb0879d9a2c8c7ad226584824a4715374f4471f16febd9ef5e62e0a15473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b62297f819b50827990c362a30b984ce787e4fdb68d003f40390aafb16d9d45"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4c/9f/866d602492987854ecbec3d29119738d33b584f38c2e8d4ff26e3bf968e8/boto3-1.35.93.tar.gz"
    sha256 "2446e819cf4e295833474cdcf2c92bc82718ce537e9ee1f17f7e3d237f60e69b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d7/4f/95d69a973620d2e9377e5dca0a5ffe0c0767e3a6764161ca995e2bab1636/botocore-1.35.93.tar.gz"
    sha256 "b8d245a01e7d64c41edcf75a42be158df57b9518a83a3dbf5c7e4b8c2bc540cc"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/76/4b/3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefb/cached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/e7/b8/91054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7/click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/45/0b/8c7eaf1e2152f1e0fb28ae7b22e2b35a6b1992953a1ebe0371ba4d41d3ad/orjson-3.10.13.tar.gz"
    sha256 "eb9bfb14ab8f68d9d9492d4817ae497788a15fd7da72e14dfabc289c3bb088ec"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/bc/4b/e03bbe626379bfee06c944a01ef25ad14ce30bc9dd86988dfda1cf343347/policy_sentry-0.14.0.tar.gz"
    sha256 "5c52cebebad26e2360393f34af523c1685541d67b0dfd721b0779dbe9e327f1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/c0/0a/1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069/s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/d4/01/0ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecd/schema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cloudsplaining", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudsplaining --version")

    output = shell_output("#{bin}/cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end
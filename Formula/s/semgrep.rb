class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/semgrep/semgrep.git",
      tag:      "v1.104.0",
      revision: "c13040ce1b5a23f1309820ca99cd27da29ecd0eb"
  license "LGPL-2.1-only"
  head "https://github.com/semgrep/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4962672480dc406bea615b48d139560916709b91bd1c851810c167eb9abc441c"
    sha256 cellar: :any,                 arm64_sonoma:  "91d27f95905d452d6c1199abb4f6a72c9e76b58d0b2135064cdbfdc06e9f372e"
    sha256 cellar: :any,                 arm64_ventura: "8caf6659359791200fa02fd32f30c9196cb8eda16b2aab9696eb5486246d6f7f"
    sha256 cellar: :any,                 sonoma:        "2cce5fcd963043bb699352065539d844748b992adf0bcb21b0194749995722c6"
    sha256 cellar: :any,                 ventura:       "6bc6db4ad6999d5390771f2ecce51e8521a2f9b695732c8283abd9706367846b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "457583255ccafdf517deffeef05386ef79ec16394dcf728e49c485f3e5bf79e1"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pipenv" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "gmp"
  depends_on "libev"
  depends_on "pcre"
  depends_on "pcre2"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "tree-sitter"

  uses_from_macos "rsync" => :build
  uses_from_macos "curl"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/48/c8/6260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045/attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/ad/1f/6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502/boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/d6/6c/57418c4404cd22fe6275b8301ca2b46a8cdaa8157938017a9ae0b3edf363/bracex-2.5.post1.tar.gz"
    sha256 "12c50952415bfa773d2d9ccb8e79651b8cdb1f31a42f6091b804f6ba2b4a66b6"
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

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/2e/a3/53e7d78a6850ffdd394d7048a31a6f14e44900adedf190f9a165f6b69439/deprecated-1.2.15.tar.gz"
    sha256 "683e561a90de76239796e6b6feac66b99030d2dd3fcf61ef996330f14bbb9b0d"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/09/35/2495c4ac46b980e4ca1f6ad6db102322ef3ad2410b79fdde159a4b0f3b92/exceptiongroup-1.2.2.tar.gz"
    sha256 "47c2edf7c6738fafb49fd34290706d1a1a2f4d1c6df275526b62cbb4aa5393cc"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/ac/79/2484075a8549cd64beae697a8f664dee69a5ccf3a7439ee40c8f93c1978a/face-24.0.0.tar.gz"
    sha256 "611e29a01ac5970f0077f9c577e746d48c082588b411b33a0dd55c4d872949f6"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/3f/d1/69432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6/glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/ff/a7/8e9cccdb1c49870de6faea2a2764fa23f627dd290633103540209f03524c/googleapis_common_protos-1.66.0.tar.gz"
    sha256 "c3e7b33d15fdca5374cc0a7346dd92ffa847425cc4ea941d970f13680052ec8c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/df/0d/10357006dc10fc65f7c7b46c18232e466e355f9e606ac461cfc7193b4cbe/opentelemetry_api-1.25.0.tar.gz"
    sha256 "77c4985f62f2614e42ce77ee4c9da5fa5f0bc1e1821085e9a47533a9323ae869"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/37/a7/85ffaaacd712e4634fa1c56cbf79a02cf90b8a178fe1eee2cabfb0b7f44d/opentelemetry_exporter_otlp_proto_common-1.25.0.tar.gz"
    sha256 "c93f4e30da4eee02bacd1e004eb82ce4da143a2f8e15b987a9f603e0a85407d3"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/72/d9/1c3c518853c27d323a46813d3e99d601959ca2c6963d5217fe2110f0d579/opentelemetry_exporter_otlp_proto_http-1.25.0.tar.gz"
    sha256 "9f8723859e37c75183ea7afa73a3542f01d0fd274a5b97487ea24cb683d7d684"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/0f/20/0a5d980843e048e9516443a91c63a559b40e5d50a730e73e72a5bde727fd/opentelemetry_instrumentation-0.46b0.tar.gz"
    sha256 "974e0888fb2a1e01c38fbacc9483d024bb1132aad92d6d24e2e5543887a7adda"
  end

  resource "opentelemetry-instrumentation-requests" do
    url "https://files.pythonhosted.org/packages/f6/28/5b5e9fb74639e47f026a3fd6550bba965ca18b316a8178907540e711855c/opentelemetry_instrumentation_requests-0.46b0.tar.gz"
    sha256 "ef0ad63bfd0d52631daaf7d687e763dbd89b465f5cb052f12a4e67e5e3d181e4"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/c9/3c/28c9ce40eb8ab287471af81659089ca98ef4f7ce289669e23b19c29f24a8/opentelemetry_proto-1.25.0.tar.gz"
    sha256 "35b6ef9dc4a9f7853ecc5006738ad40443701e52c26099e197895cbda8b815a3"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/05/3c/77076b77f1d73141adc119f62370ec9456ef314ba0b4e7072e3775c36ef7/opentelemetry_sdk-1.25.0.tar.gz"
    sha256 "ce7fc319c57707ef5bf8b74fb9f8ebdb8bfafbe11898410e0d2a761d08a98ec7"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/4e/ea/a4a5277247b3d2ed2e23a58b0d509c2eafa4ebb56038ba5b23c0f9ea6242/opentelemetry_semantic_conventions-0.46b0.tar.gz"
    sha256 "fbc982ecbb6a6e90869b15c1673be90bd18c8a56ff1cffc0864e38e2edffaefa"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/f0/91/45bf243850463b2c83000ca129442255eaef7c446bd0f59a2ab54b15abff/opentelemetry_util_http-0.46b0.tar.gz"
    sha256 "03b6e222642f9c7eae58d9132343e045b50aca9761fcb53709bd2b663571fdf6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/b4/dc/832bcf4ea5ee2ebc4ea42ef36e44a451de5d80f8b9858bf2066e30738c67/peewee-3.17.8.tar.gz"
    sha256 "ce1d05db3438830b989a1b9d0d0aa4e7f6134d5f6fd57686eeaa26a3e6485a8c"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/67/dd/48d5fdb68ec74d70fabcc252e434492e56f70944d9f17b6a15e3746d2295/protobuf-4.25.5.tar.gz"
    sha256 "7f8249476b4a9473645db7f8ab42b02fe1488cbe5fb72fddd445e0665afd8584"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/27/32/fd98246df7a0f309b58cae68b10b6b219ef2eb66747f00dfb34422687087/referencing-0.36.1.tar.gz"
    sha256 "ca2e6492769e3602957e9b831b94211599d2aade9477f5d44110d2530cf9aade"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1d/d6/9773d48804d085962c4f522db96f6a9ea9bd2e0480b3959a929176d92f01/rich-13.5.3.tar.gz"
    sha256 "87b43e0543149efa1253f485cd845bb7ee54df16c9617b8a893650ab84b4acb6"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/01/80/cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfd/rpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/35/b9/de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264b/tomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/ea/c4/55e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968/wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    # Ensure dynamic linkage to our libraries
    inreplace "src/main/flags.sh" do |s|
      s.gsub!("$(ospack --prefix libev)/lib/libev.a", Formula["libev"].opt_lib/shared_library("libev"))
      s.gsub!("$(pkg-config gmp --variable libdir)/libgmp.a", Formula["gmp"].opt_lib/shared_library("libgmp"))
      s.gsub!(
        "$(pkg-config tree-sitter --variable libdir)/libtree-sitter.a",
        Formula["tree-sitter"].opt_lib/shared_library("libtree-sitter"),
      )
      s.gsub!(
        "$(pkg-config libpcre --variable libdir)/libpcre.a",
        Formula["pcre"].opt_lib/shared_library("libpcre"),
      )
      s.gsub!(
        "$(pkg-config libpcre2-8 --variable libdir)/libpcre2-8.a",
        Formula["pcre2"].opt_lib/shared_library("libpcre2-8"),
      )
    end

    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      # `--no-depexts` prevents opam from attempting to automatically search for
      # and install system dependencies using the os-native package manager.
      # On Linux, this leads to confusing and inaccurate `Missing dependency`
      # errors due to querying `apt`. See:
      #   https://github.com/ospack/core/pull/82693
      #   https://github.com/ospack/core/pull/176636
      #   https://github.com/ocaml/opam/pull/4548
      ENV["OPAMNODEPEXTS"] = ENV["OPAMYES"] = "1"
      # Set library path so opam + lwt can find libev
      ENV["LIBRARY_PATH"] = "#{OSPACK_PREFIX}/lib"
      # Opam's solver times out when it is set to the default of 60.0
      # See: https://github.com/ospack/core/pull/191306
      ENV["OPAMSOLVERTIMEOUT"] = "1200"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.14.0" }

      # Manually run steps from `opam exec -- make setup` to link Ospack's tree-sitter
      system "opam", "update", "-y"
      system "opam", "install", "-y", "--deps-only", "./libs/ocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "./"
      cd "./libs/ocaml-tree-sitter-core" do
        system "./configure"
      end

      # Install semgrep-core and spacegrep
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "copy-core-for-cli"

      bin.install "_build/install/default/bin/semgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources.reject { |r| r.name == "glom" }

    # Replace `imp` usage: https://github.com/mahmoud/glom/commit/1f883f0db898d6b15fcc0f293225dcccc16b2a57
    # TODO: remove with glom>=23.4.0
    resource("glom").stage do |r|
      inreplace "setup.py", "import imp", ""
      inreplace "setup.py", "_version_mod = imp.load_source('_version', _version_mod_path)", ""
      inreplace "setup.py", "_version_mod.__version__", "'#{r.version}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath/"cli"

    generate_completions_from_executable(bin/"semgrep", "--legacy",
                                         shells:                 [:fish, :zsh],
                                         shell_parameter_format: :click)
  end

  test do
    system bin/"semgrep", "--help"
    (testpath/"script.py").write <<~PYTHON
      def silly_eq(a, b):
        return a + b == a + b
    PYTHON

    output = shell_output("#{bin}/semgrep script.py -l python -e '$X == $X'")
    assert_match "a + b == a + b", output

    (testpath/"script.ts").write <<~TYPESCRIPT
      function test_equal() {
        a = 1;
        b = 2;
        //ERROR: match
        if (a + b == a + b)
            return 1;
        return 0;
      }
    TYPESCRIPT

    output = shell_output("#{bin}/semgrep script.ts -l ts -e '$X == $X'")
    assert_match "a + b == a + b", output
  end
end
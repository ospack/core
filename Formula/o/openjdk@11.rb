class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.26-ga.tar.gz"
  sha256 "85b260f8ac5ed26b9881e353700c98e768d8cb17a484ef062fb0aa56494a32bf"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3c659034bc90ee8ca7ab95ecf827fb931fc2b95cdb5ac919484a815b8a6bf68"
    sha256 cellar: :any,                 arm64_sonoma:  "f61e43d2c40ca3b9318fb5c40b7efbee0e30ce4a28028147f0192966430a1bf3"
    sha256 cellar: :any,                 arm64_ventura: "4e4699812eea7effb4edd4808f4db2ef60b524df948c565d51bebfc670b87198"
    sha256 cellar: :any,                 sonoma:        "91c18c01f5b7c5473b7e3cfcfc385c6a6bbe349dd8a510632d334d0c7b53735d"
    sha256 cellar: :any,                 ventura:       "b76694cf810f05c71397f8250dd839e080d4902df3d5c04fa0b72b2751152826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8584a6bab9db1a6571dd5ee9fcd4e27ec58b8cf816ffe69405bf6b0e158901fc"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_macos do
    if DevelopmentTools.clang_build_version == 1600
      depends_on "llvm" => :build

      fails_with :clang do
        cause "fatal error while optimizing exploded image for BUILD_JIGSAW_TOOLS"
      end

      # Backport fix for UB that errors on LLVM 19
      patch do
        url "https://github.com/openjdk/jdk/commit/51be7db96f3fc32a7ddb24f8af19fb4fc0577aaf.patch?full_index=1"
        sha256 "7fb09ce74a1cf534c976d0ea8aec285c86a832fe4fa016bdf79870ac5574b9a7"
      end

      # Apply FreeBSD workaround to avoid UB causing failure on recent Clang.
      # A proper fix requires backport of 8229258[^1] which was previously attempted[^2].
      #
      # [^1]: https://bugs.openjdk.org/browse/JDK-8229258
      # [^2]: https://github.com/openjdk/jdk11u/pull/23
      patch do
        url "https://github.com/battleblow/jdk11u/commit/305a68a90c722aa7a7b75589e24d5b5d554c96c1.patch?full_index=1"
        sha256 "5327c249c379a8db6a9e844e4fb32471506db8b8e3fef1f62f5c0c892684fe15"
      end
    end
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  # ARM64: https://www.azul.com/downloads/?version=java-11-lts&package=jdk
  # Intel: https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.68.17-ca-jdk11.0.21-macosx_aarch64.tar.gz"
        sha256 "f7b7d10d42b75f9ac8e7311732d039faee2ce854b9ad462e0936e6c88d01a19f"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
        sha256 "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
      end
    end
    on_linux do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.68.17-ca-jdk11.0.21-linux_aarch64.tar.gz"
        sha256 "5638887df0e680c890b4c6f9543c9b61c96c90fb01f877d79ae57566466d3b3d"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
        sha256 "99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57"
      end
    end
  end

  def install
    if DevelopmentTools.clang_build_version == 1600
      ENV.llvm_clang
      ENV.remove "OSPACK_LIBRARY_PATHS", Formula["llvm"].opt_lib
      # ptrauth.h is not available in ospack LLVM
      inreplace "src/hotspot/os_cpu/bsd_aarch64/pauth_bsd_aarch64.inline.hpp" do |s|
        s.sub! "#include <ptrauth.h>", ""
        s.sub! "return ptrauth_strip(ptr, ptrauth_key_asib);", "return ptr;"
      end
    end

    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac? && !Hardware::CPU.arm?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-hotspot-gtest
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-jvm-features=shenandoahgc
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --without-version-opt
      --without-version-pre
      --with-freetype=system
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server"]
    args += if OS.mac?
      ldflags << "-headerpad_max_install_names"

      # Allow unbundling `freetype` on macOS
      inreplace "make/autoconf/lib-freetype.m4", '= "xmacosx"', '= ""'

      %W[
        --enable-dtrace
        --with-freetype-include=#{Formula["freetype"].opt_include}
        --with-freetype-lib=#{Formula["freetype"].opt_lib}
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{OSPACK_PREFIX}
        --with-cups=#{OSPACK_PREFIX}
        --with-fontconfig=#{OSPACK_PREFIX}
        --with-stdc++lib=dynamic
      ]
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images", "CONF=release"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/release/images/jdk-bundle/*"].first => "openjdk.jdk"
      jdk /= "openjdk.jdk/Contents/Home"
    else
      libexec.install Dir["build/release/images/jdk/*"]
    end

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~JAVA
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
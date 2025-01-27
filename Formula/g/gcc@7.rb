class GccAT7 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-7.5.0/gcc-7.5.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-7.5.0/gcc-7.5.0.tar.xz"
  sha256 "b81946e7f01f90528a1f7352ab08cc602b9ccc05d4e44da4bd501c5a189ee661"
  license all_of: [
    "LGPL-2.1-or-later",
    "GPL-3.0-or-later" => { with: "GCC-exception-3.1" },
  ]
  revision 4

  bottle do
    rebuild 1
    sha256                               monterey:     "485a30f3812ce487ea861c68e8e3f1ddb209fb223bb1ef8c078a03615469b805"
    sha256                               big_sur:      "66814f42364cea53786f3bb5d5b87caa9c89d43da6c743c38c84f06cfa368376"
    sha256                               catalina:     "22a7358ee5e81ef25f858fbc6305669daa53c659d7d32198c9170a0ef83ed4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e653d70c78fb9bcd714a6904775dcd9c3b2e661efd633722519f347e190c7c8f"
  end

  # Unsupported per https://gcc.gnu.org/gcc-7/
  # Last release on 2019-11-14
  disable! date: "2024-02-22", because: :deprecated_upstream

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on maximum_macos: [:monterey, :build]
  depends_on arch: :x86_64
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def version_suffix
    version.major.to_s
  end

  def install
    # Fix flat namespace use on macOS.
    configure_paths = %w[
      libatomic
      libgfortran
      libgomp
      libitm
      libobjc
      libquadmath
      libssp
      libstdc++-v3
    ]
    configure_paths.each do |path|
      inreplace buildpath/path/"configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress",
                                            "${wl}-undefined ${wl}dynamic_lookup"
    end

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"

    # We avoiding building:
    #  - Ada, which requires a pre-existing GCC Ada compiler to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    args = [
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version_suffix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-isl=#{Formula["isl"].opt_prefix}",
      "--enable-checking=release",
      "--with-pkgversion=Ospack GCC #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=#{tap.issues_url}",
      "--disable-nls",
    ]

    if OS.mac?
      args << "--build=x86_64-apple-darwin#{OS.kernel_version}"
      args << "--with-system-zlib"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
      end

      # Ensure correct install names when linking against libgcc_s;
      # see discussion in https://github.com/Ospack/ospack/pull/34303
      inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{OSPACK_PREFIX}/lib/gcc/#{version_suffix}"
    else
      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc-pass2.html
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
    end

    mkdir "build" do
      system "../configure", *args

      system "make"
      if OS.mac?
        system "make", "install"
      else
        system "make", "install-strip"
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    rm_r(info)
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    if OS.linux?
      gcc = bin/"gcc-#{version_suffix}"
      libgcc = Pathname.new(Utils.safe_popen_read(gcc, "-print-libgcc-file-name")).parent
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

      glibc = Formula["glibc"]
      glibc_installed = glibc.any_version_installed?

      # Symlink crt1.o and friends where gcc can find it.
      crtdir = if glibc_installed
        glibc.opt_lib
      else
        Pathname.new(Utils.safe_popen_read("/usr/bin/cc", "-print-file-name=crti.o")).parent
      end
      ln_sf Dir[crtdir/"*crt?.o"], libgcc

      # Create the GCC specs file
      # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

      # Locate the specs file
      specs = libgcc/"specs"
      ohai "Creating the GCC specs file: #{specs}"
      specs_orig = Pathname.new("#{specs}.orig")
      rm([specs_orig, specs].select(&:exist?))

      system_header_dirs = ["#{OSPACK_PREFIX}/include"]

      if glibc_installed
        # https://github.com/Linuxospack/ospack/issues/724
        system_header_dirs << glibc.opt_include
      else
        # Locate the native system header dirs if user uses system glibc
        target = Utils.safe_popen_read(gcc, "-print-multiarch").chomp
        raise "command failed: #{gcc} -print-multiarch" if $CHILD_STATUS.exitstatus.nonzero?

        system_header_dirs += ["/usr/include/#{target}", "/usr/include"]
      end

      # Save a backup of the default specs file
      specs_string = Utils.safe_popen_read(gcc, "-dumpspecs")
      raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?

      specs_orig.write specs_string

      # Set the library search path
      # For include path:
      #   * `-isysroot #{OSPACK_PREFIX}/nonexistent` prevents gcc searching built-in
      #     system header files.
      #   * `-idirafter <dir>` instructs gcc to search system header
      #     files after gcc internal header files.
      # For libraries:
      #   * `-nostdlib -L#{libgcc}` instructs gcc to use ospacked glibc
      #     if applied.
      #   * `-L#{libdir}` instructs gcc to find the corresponding gcc
      #     libraries. It is essential if there are multiple ospacked gcc
      #     with different versions installed.
      #     Noted that it should only be passed for the `gcc@*` formulae.
      #   * `-L#{OSPACK_PREFIX}/lib` instructs gcc to find the rest
      #     ospack libraries.
      libdir = OSPACK_PREFIX/"lib/gcc/#{version_suffix}"
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot #{OSPACK_PREFIX}/nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

        *link_libgcc:
        #{glibc_installed ? "-nostdlib -L#{libgcc}" : "+"} -L#{libdir} -L#{OSPACK_PREFIX}/lib

        *link:
        + --dynamic-linker #{OSPACK_PREFIX}/lib/ld.so -rpath #{libdir} -rpath #{OSPACK_PREFIX}/lib

      EOS
    end
  end

  test do
    (testpath/"hello-c.c").write <<~C
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"gcc-#{version.major}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~CPP
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    system bin/"g++-#{version.major}", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", `./hello-cc`

    (testpath/"test.f90").write <<~FORTRAN
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    FORTRAN
    system bin/"gfortran-#{version.major}", "-o", "test", "test.f90"
    assert_equal "Done\n", `./test`
  end
end

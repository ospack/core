class PythonFreethreading < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.1/Python-3.13.1.tgz"
  sha256 "1513925a9f255ef0793dbf2f78bb4533c9f184bdd0ad19763fd7f47a400a7c55"
  license "Python-2.0"

  livecheck do
    formula "python"
  end

  bottle do
    sha256 arm64_sequoia: "7211fee73765cfcff327a0ebc4ec1b94e0a643fe3d3e129f8de20f96eb4fb07b"
    sha256 arm64_sonoma:  "6e1c62a4b9a2e5774e3aee4d45cd1843702a6de428ecde40fb530c5101f6b19e"
    sha256 arm64_ventura: "525f8dcad47a991548d4c5b80de69591ce2f043365d215dcdbf8ca75b7348423"
    sha256 sonoma:        "ad8826d5a47f1ed24298e7b99cfa4aa7af3f36ff5ef610a06295a519a03abbe2"
    sha256 ventura:       "b7fa4357a434417197a240e0a7d1eb2b0ec4667608c3f7b110cdd70efbc0064f"
    sha256 x86_64_linux:  "8a9c28d43f6af78a8ac174a357b37762eebc168597fdc9843c4412f71ee4b7cf"
  end

  depends_on "pkgconf" => :build
  depends_on "mpdecimal"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "xz"

  # not actually used, we just want this installed to ensure there are no conflicts.
  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "berkeley-db@5"
    depends_on "libnsl"
    depends_on "libtirpc"
  end

  # Always update to latest release
  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/d5/ae/09427bea9227a33ec834ed5461432752fd5d02b14f93dd68406c91684622/flit_core-3.10.1.tar.gz"
    sha256 "66e5b87874a0d6e39691f0e22f09306736b633548670ad3c09ec9db03c5662f7"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/f4/b1/b422acd212ad7eedddaf7981eee6e5de085154ff726459cf2da7c5a184c1/pip-24.3.1.tar.gz"
    sha256 "ebcb60557f2aefabc2e0f918751cd24ea0d56d8ec5445fe1807f1d2109660b99"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  # Modify default sysconfig to match the ospack install layout.
  # Remove when a non-patching mechanism is added (https://bugs.python.org/issue43976).
  # We (ab)use osx_framework_library to exploit pip behaviour to allow --prefix to still work.
  patch do
    url "https://raw.githubusercontent.com/Ospack/formula-patches/22f07354b9778579dd3297bbce0ed3d3244dd982/python/3.13-sysconfig.diff"
    sha256 "9f2eae1d08720b06ac3d9ef1999c09388b9db39dfb52687fc261ff820bff20c3"
  end

  def lib_cellar
    on_macos do
      return frameworks/"PythonT.framework/Versions"/version.major_minor/"lib/python#{version.major_minor}t"
    end
    on_linux do
      return lib/"python#{version.major_minor}t"
    end
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The OSPACK_PREFIX location of site-packages.
  def site_packages
    OSPACK_PREFIX/"lib/python#{version.major_minor}t/site-packages"
  end

  def python3
    bin/"python#{version.major_minor}t"
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    # Override the auto-detection of libmpdec, which assumes a universal build.
    # This is currently an inreplace due to https://github.com/python/cpython/issues/98557.
    if OS.mac?
      inreplace "configure", "libmpdec_machine=universal",
                "libmpdec_machine=#{ENV["PYTHON_DECIMAL_WITH_MACHINE"] = Hardware::CPU.arm? ? "uint128" : "x64"}"
    end

    # The --enable-optimization and --with-lto flags diverge from what upstream
    # python does for their macOS binary releases. They have chosen not to apply
    # these flags because they want one build that will work across many macOS
    # releases. Ospack is not so constrained because the bottling
    # infrastructure specializes for each macOS major release.
    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --without-ensurepip
      --enable-loadable-sqlite-extensions
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-optimizations
      --with-system-expat
      --with-system-libmpdec
      --with-readline=editline
      --disable-gil
    ]

    # Python re-uses flags when building native modules.
    # Since we don't want native modules prioritizing the ospack
    # include path, we move them to [C|LD]FLAGS_NODIST.
    # Note: Changing CPPFLAGS causes issues with dbm, so we
    # leave it as-is.
    cflags         = []
    cflags_nodist  = ["-I#{OSPACK_PREFIX}/include"]
    ldflags        = []
    ldflags_nodist = ["-L#{OSPACK_PREFIX}/lib", "-Wl,-rpath,#{OSPACK_PREFIX}/lib"]
    cppflags       = ["-I#{OSPACK_PREFIX}/include"]

    if OS.mac?
      # Enabling LTO on Linux makes libpython3.*.a unusable for anyone whose GCC
      # install does not match the one in CI _exactly_ (major and minor version).
      # https://github.com/orgs/Ospack/discussions/3734
      args << "--with-lto"
      args << "--enable-framework=#{frameworks}"
      args << "--with-framework-name=PythonT"
      args << "--with-dtrace"
      args << "--with-dbmliborder=ndbm"

      # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
      args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    else
      args << "--enable-shared"
      args << "--with-dbmliborder=bdb"
    end

    # Allow python modules to use ctypes.find_library to find ospack's stuff
    # even if ospack is not a /usr/local/lib. Try this with:
    # `ospack install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
              "DEFAULT_LIBRARY_FALLBACK = [ '#{OSPACK_PREFIX}/lib', '#{Formula["openssl@3"].opt_lib}',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{OSPACK_PREFIX}/Frameworks',"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "CFLAGS_NODIST=#{cflags_nodist.join(" ")}" unless cflags_nodist.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "LDFLAGS_NODIST=#{ldflags_nodist.join(" ")}" unless ldflags_nodist.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    # Disabled modules - provided in separate formulae
    args += %w[
      py_cv_module__tkinter=disabled
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize do
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}" if OS.mac?
    end

    if OS.mac?
      # Any .app get a " 3" attached, so it does not conflict with python 2.x.
      prefix.glob("*.app") { |app| mv app, app.to_s.sub(/\.app$/, " 3.app") }

      pc_dir = lib_cellar.parent/"pkgconfig"

      # Symlink the pkgconfig files into OSPACK_PREFIX so they're accessible.
      (lib/"pkgconfig").install_symlink pc_dir.glob("*#{version.major_minor}t*")

      # Prevent third-party packages from building against fragile Cellar paths
      bad_cellar_path_files = [
        lib_cellar/"_sysconfigdata_t_darwin_darwin.py",
        lib_cellar/"config-#{version.major_minor}t-darwin/Makefile",
        pc_dir/"python-#{version.major_minor}t.pc",
        pc_dir/"python-#{version.major_minor}t-embed.pc",
      ]
      inreplace bad_cellar_path_files, prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace lib_cellar/"config-#{version.major_minor}t-darwin/Makefile",
                /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Fix for https://github.com/ospack/core/issues/21212
      inreplace lib_cellar/"_sysconfigdata_t_darwin_darwin.py",
                %r{('LINKFORSHARED': .*?) (PythonT.framework/Versions/3.\d+/PythonT)'}m,
                "\\1 #{opt_prefix}/Frameworks/\\2'"

    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar/"**/_sysconfigdata_t_*linux_x86_64-*.py",
                    lib_cellar/"config*/Makefile",
                    bin/"python#{version.major_minor}t-config",
                    lib/"pkgconfig/python-3*.pc"],
                prefix, opt_prefix

      inreplace bin/"python#{version.major_minor}t-config",
                'prefix_real=$(installed_prefix "$0")',
                "prefix_real=#{opt_prefix}"
    end

    # Remove the site-packages that Python created in its Cellar.
    rm_r(site_packages_cellar)

    # Prepare a wheel of wheel to install later.
    common_pip_args = %w[
      -v
      --no-deps
      --no-binary :all:
      --no-index
      --no-build-isolation
    ]
    whl_build = buildpath/"whl_build"
    system python3, "-m", "venv", whl_build
    %w[flit-core wheel setuptools].each do |r|
      resource(r).stage do
        system whl_build/"bin/pip3", "install", *common_pip_args, "."
      end
    end
    resource("wheel").stage do
      system whl_build/"bin/pip3", "wheel", *common_pip_args,
                                            "--wheel-dir=#{libexec}",
                                            "."
    end

    # Replace bundled pip with our own.
    rm lib_cellar.glob("ensurepip/_bundled/pip-*.whl")
    %w[pip].each do |r|
      resource(r).stage do
        system whl_build/"bin/pip3", "wheel", *common_pip_args,
                                              "--wheel-dir=#{lib_cellar}/ensurepip/_bundled",
                                              "."
      end
    end

    # Patch ensurepip to bootstrap our updated version of pip
    inreplace lib_cellar/"ensurepip/__init__.py" do |s|
      s.gsub!(/_PIP_VERSION = .*/, "_PIP_VERSION = \"#{resource("pip").version}\"")
    end

    # Write out sitecustomize.py
    (lib_cellar/"sitecustomize.py").atomic_write(sitecustomize)

    # Rename idle, pydoc to t variants
    mv bin/"idle#{version.major_minor}", bin/"idle#{version.major_minor}t"
    mv bin/"pydoc#{version.major_minor}", bin/"pydoc#{version.major_minor}t"

    # Remove files that conflict with the main python3 formula
    bin.glob("{idle,pydoc}3").map(&:unlink)
    [bin, lib, lib/"pkgconfig", include].each do |directory|
      (directory.glob("*python*") - directory.glob("*#{version.major_minor}t*")).map(&:unlink)
    end
    rm_r share
  end

  def post_install
    ENV.delete "PYTHONPATH"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in OSPACK_PREFIX/lib/python#{version.major_minor}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Remove old sitecustomize.py. Now stored in the cellar.
    rm_r(Dir["#{site_packages}/sitecustomize.py[co]"])

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_r(Dir["#{site_packages}/distribute[-_.][0-9]*", "#{site_packages}/distribute"])
    rm_r(Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"])
    rm_r(Dir["#{site_packages}/wheel[-_.][0-9]*", "#{site_packages}/wheel"])

    (lib_cellar/"EXTERNALLY-MANAGED").unlink if (lib_cellar/"EXTERNALLY-MANAGED").exist?
    system python3, "-Im", "ensurepip"

    # Install desired versions of pip, wheel using the version of
    # pip bootstrapped by ensurepip.
    # Note that while we replaced the ensurepip wheels, there's no guarantee
    # ensurepip actually used them, since other existing installations could
    # have been picked up (and we can't pass --ignore-installed).
    bundled = lib_cellar/"ensurepip/_bundled"
    system python3, "-Im", "pip", "install", "-v",
           "--no-deps",
           "--no-index",
           "--upgrade",
           "--isolated",
           "--target=#{site_packages}",
           bundled/"pip-#{resource("pip").version}-py3-none-any.whl",
           libexec/"wheel-#{resource("wheel").version}-py3-none-any.whl"

    # pip install with --target flag will just place the bin folder into the
    # target, so move its contents into the appropriate location
    mv (site_packages/"bin").children, bin
    rmdir site_packages/"bin"

    rm [bin/"pip", bin/"pip3"]
    mv bin/"wheel", bin/"wheel#{version.major_minor}t"
    mv bin/"pip#{version.major_minor}", bin/"pip#{version.major_minor}t"

    # post_install happens after link
    (OSPACK_PREFIX/"bin").install_symlink (%w[pip wheel].map do |executable|
      bin/"#{executable}#{version.major_minor}t"
    end)

    # Mark Ospack python as externally managed: https://peps.python.org/pep-0668/#marking-an-interpreter-as-using-an-external-package-manager
    # Placed after ensurepip since it invokes pip in isolated mode, meaning
    # we can't pass --break-system-packages.
    (lib_cellar/"EXTERNALLY-MANAGED").write <<~INI
      [externally-managed]
      Error=To install Python packages system-wide, try ospack install
       xyz, where xyz is the package you are trying to
       install.

       If you wish to install a Python library that isn't in Ospack,
       use a virtual environment:

         #{python3.basename} -m venv path/to/venv
         source path/to/venv/bin/activate
         #{python3.basename} -m pip install xyz

       If you wish to install a Python application that isn't in Ospack,
       it may be easiest to use 'pipx install xyz', which will manage a
       virtual environment for you. You can install pipx with

         ospack install pipx

       You may restore the old behavior of pip by passing
       the '--break-system-packages' flag to pip, or by adding
       'break-system-packages = true' to your pip.conf file. The latter
       will permanently disable this error.

       If you disable this error, we STRONGLY recommend that you additionally
       pass the '--user' flag to pip, or set 'user = true' in your pip.conf
       file. Failure to do this can result in a broken Ospack installation.

       Read more about this behavior here: <https://peps.python.org/pep-0668/>
    INI
  end

  def sitecustomize
    <<~PYTHON
      # This file is created by Ospack and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.ospack.github.io/Ospack-and-Python>
      import re
      import os
      import site
      import sys
      if sys.version_info[:2] != (#{version.major}, #{version.minor}):
          # This can only happen if the user has set the PYTHONPATH to a mismatching site-packages directory.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit(f'Your PYTHONPATH points to a site-packages dir for Python #{version.major_minor} '
               f'but you are running Python {sys.version_info[0]}.{sys.version_info[1]}!\\n'
               f'     PYTHONPATH is currently: "{os.environ["PYTHONPATH"]}"\\n'
               f'     You should `unset PYTHONPATH` to fix this.')
      # Only do this for a ospacked python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{version.major_minor}t/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)
          # the Cellar site-packages is a symlink to the OSPACK_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\\._abrc]+/Frameworks/PythonT\\.framework/Versions/#{version.major_minor}/lib/python#{version.major_minor}t/site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]
          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = sys._base_executable = '#{opt_bin}/python#{version.major_minor}t'
      if 'PYTHONHOME' not in os.environ:
          cellar_prefix = re.compile(r'#{rack}/[0-9\\._abrc]+/')
          if os.path.realpath(sys.base_prefix).startswith('#{rack}'):
              new_prefix = cellar_prefix.sub('#{opt_prefix}/', sys.base_prefix)
              if sys.prefix == sys.base_prefix:
                  site.PREFIXES[:] = [new_prefix if x == sys.prefix else x for x in site.PREFIXES]
                  sys.prefix = new_prefix
              sys.base_prefix = new_prefix
          if os.path.realpath(sys.base_exec_prefix).startswith('#{rack}'):
              new_exec_prefix = cellar_prefix.sub('#{opt_prefix}/', sys.base_exec_prefix)
              if sys.exec_prefix == sys.base_exec_prefix:
                  site.PREFIXES[:] = [new_exec_prefix if x == sys.exec_prefix else x for x in site.PREFIXES]
                  sys.exec_prefix = new_exec_prefix
              sys.base_exec_prefix = new_exec_prefix
      # Check for and add the prefix of split Python formulae.
      for split_module in ["tk", "gdbm"]:
          split_prefix = f"#{OSPACK_PREFIX}/opt/python-{split_module}@#{version.major_minor}t/libexec"
          if os.path.isdir(split_prefix):
              sys.path.append(split_prefix)
    PYTHON
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{OSPACK_PREFIX}/bin/#{python3.basename}

      See: https://docs.ospack.github.io/Ospack-and-Python
    EOS
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system python3, "-c", "import sqlite3"

    # check to see if we can create a venv
    system python3, "-m", "venv", testpath/"myvenv"

    # Check if some other modules import. Then the linked libs are working.
    system python3, "-c", "import _ctypes"
    system python3, "-c", "import _decimal"
    system python3, "-c", "import pyexpat"
    system python3, "-c", "import readline"
    system python3, "-c", "import zlib"

    # tkinter is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_tkinter'",
                 shell_output("#{python3} -Sc 'import tkinter' 2>&1", 1)

    # gdbm is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import _gdbm' 2>&1", 1)
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import dbm.gnu' 2>&1", 1)

    # Verify that the selected DBM interface works
    (testpath/"dbm_test.py").write <<~PYTHON
      import dbm

      with dbm.ndbm.open("test", "c") as db:
          db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
          assert list(db.keys()) == [b"foo \\xbd"]
          assert b"foo \\xbd" in db
          assert db[b"foo \\xbd"] == b"bar \\xbd"
    PYTHON
    system python3, "dbm_test.py"

    system bin/"pip#{version.major_minor}t", "list", "--format=columns"

    # Verify our sysconfig patches
    sysconfig_path = "import sysconfig; print(sysconfig.get_paths(\"osx_framework_library\")[\"data\"])"
    assert_equal OSPACK_PREFIX.to_s, shell_output("#{python3} -c '#{sysconfig_path}'").strip
    linkforshared_var = "import sysconfig; print(sysconfig.get_config_var(\"LINKFORSHARED\"))"
    assert_match opt_prefix.to_s, shell_output("#{python3} -c '#{linkforshared_var}'") if OS.mac?

    # Check our externally managed marker
    assert_match "If you wish to install a Python library",
                 shell_output("#{python3} -m pip install pip 2>&1", 1)
    assert_equal "False", shell_output("#{python3} -c 'import sys; print(sys._is_gil_enabled())'").chomp
  end
end
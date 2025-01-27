class PerconaServerAT80 < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://downloads.percona.com/downloads/Percona-Server-8.0/Percona-Server-8.0.40-31/source/tarball/percona-server-8.0.40-31.tar.gz"
  sha256 "1318670d8e176c24df74019f748f5f233e2787f865dd3d41d61790ab5a772c4e"
  license "BSD-3-Clause"

  livecheck do
    url "https://docs.percona.com/percona-server/#{version.major_minor}/"
    regex(/href=.*?v?(\d+(?:[.-]\d+)+)\.html/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        match[0].sub(/(-\d+)\.0$/, '\1')
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "3874ba009695e9129492858dcf8f330aa4aa6f6beb0a268d0c767ac940b20acd"
    sha256 arm64_sonoma:  "5454eb67a2865024f19eff4255d196a56fd719b99c15048da71ce2966e150bed"
    sha256 arm64_ventura: "e136deee3b6ee381aa98ab2a76f5f4eaca3d1e9127268aea175d0461e9e71863"
    sha256 sonoma:        "4589cfa0478a5fa1097b710a669d968afe26117afd048fa783d02b01b054be6a"
    sha256 ventura:       "7dd7eaaca4a533017df910d30a1552d688113fd8ff60d6e143d2429da4709215"
    sha256 x86_64_linux:  "ea4b86f1771f4d3ecc78bcacd53f662ae6a31a766bc13732d820d75e39efcdcf"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@76"
  depends_on "libevent"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openldap" # Needs `ldap_set_urllist_proc`, not provided by LDAP.framework
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  # https://github.com/percona/percona-server/blob/8.0/cmake/os/Darwin.cmake
  fails_with :clang do
    build 999
    cause "Requires Apple Clang 10.0 or newer"
  end

  # https://github.com/percona/percona-server/blob/Percona-Server-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.77.0/boost_1_77_0.tar.bz2"
    sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"

    livecheck do
      url "https://raw.githubusercontent.com/percona/percona-server/refs/tags/Percona-Server-#{LATEST_VERSION}/cmake/boost.cmake"
      regex(%r{/release/v?(\d+(?:\.\d+)+)/}i)
    end
  end

  # Patch out check for Ospack `boost`.
  # This should not be necessary when building inside `ospack`.
  # https://github.com/Ospack/ospack-test-bot/pull/820
  patch do
    url "https://raw.githubusercontent.com/Ospack/formula-patches/030f7433e89376ffcff836bb68b3903ab90f9cdc/mysql/boost-check.patch"
    sha256 "af27e4b82c84f958f91404a9661e999ccd1742f57853978d8baec2f993b51153"
  end

  # Fix for system ssl add_library error
  # Issue ref: https://perconadev.atlassian.net/jira/software/c/projects/PS/issues/PS-9641
  patch do
    url "https://github.com/percona/percona-server/commit/a693e5d67abf6f27f5284c86361604babec529c6.patch?full_index=1"
    sha256 "d4afcdfb0dd8dcb7c0f7e380a88605b515874628107295ab5b892e8f1e019604"
  end

  def datadir
    var/"mysql"
  end

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[coredumper duktape libkmip lz4 opensslpp rapidjson robin-hood-hashing unordered_dense]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }
    (buildpath/"boost").install resource("boost")

    # Find Ospack OpenLDAP instead of the macOS framework
    inreplace "cmake/ldap.cmake", "NAMES ldap_r ldap", "NAMES ldap"

    # Fix mysqlrouter_passwd RPATH to link to metadata_cache.so
    inreplace "router/src/http/src/CMakeLists.txt",
              "ADD_INSTALL_RPATH(mysqlrouter_passwd \"${ROUTER_INSTALL_RPATH}\")",
              "\\0\nADD_INSTALL_RPATH(mysqlrouter_passwd \"${RPATH_ORIGIN}/../${ROUTER_INSTALL_PLUGINDIR}\")"

    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Ospack
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/percona-server/plugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}/bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_BOOST=#{buildpath}/boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
      -DWITH_INNODB_MEMCACHED=ON
      -DROCKSDB_BUILD_ARCH=#{ENV.effective_arch}
    ]
    args << "-DROCKSDB_DISABLE_AVX2=ON" if build.bottle?
    args << "-DALLOW_NO_SSE42=ON" if Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse42?)
    args << "-DWITH_KERBEROS=system" unless OS.mac?

    ENV.append "CXXFLAGS", "-std=c++17"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd prefix/"mysql-test" do
      test_args = ["--vardir=#{buildpath}/mysql-test-vardir"]
      # For Linux, disable failing on warning: "Setting thread 31563 nice to 0 failed"
      # Docker containers lack CAP_SYS_NICE capability by default.
      test_args << "--nowarnings" if OS.linux?
      system "./mysql-test-run.pl", "status", *test_args
    end

    # Remove the tests directory
    rm_r(prefix/"mysql-test")

    # Fix up the control script and link into bin.
    inreplace prefix/"support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{OSPACK_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~INI
      # Default Ospack MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    INI
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["OSPACK_GITHUB_ACTIONS"]

    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
                           "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation

      MySQL is configured to only allow connections from localhost by default

      To connect run:
          mysql -u root
    EOS
    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      s += <<~EOS

        A "#{my_cnf}" from another install may interfere with a Ospack-built
        server starting up correctly.
      EOS
    end
    s
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var/"mysql"
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath

    port = free_port
    socket = testpath/"mysql.sock"
    mysqld_args = %W[
      --no-defaults
      --mysqlx=OFF
      --user=#{ENV["USER"]}
      --port=#{port}
      --socket=#{socket}
      --basedir=#{prefix}
      --datadir=#{testpath}/mysql
      --tmpdir=#{testpath}/tmp
    ]
    client_args = %W[
      --port=#{port}
      --socket=#{socket}
      --user=root
      --password=
    ]

    system bin/"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(bin/"mysqld", *mysqld_args)
    begin
      sleep 5
      output = shell_output("#{bin}/mysql #{client_args.join(" ")} --execute='show databases;'")
      assert_match "information_schema", output
    ensure
      system bin/"mysqladmin", *client_args, "shutdown"
      Process.kill "TERM", pid
    end
  end
end
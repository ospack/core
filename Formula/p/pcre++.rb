class Pcrexx < Formula
  desc "C++ wrapper for the Perl Compatible Regular Expressions"
  homepage "https://www.daemon.de/projects/pcrepp/"
  url "https://www.daemon.de/idisk/Apps/pcre++/pcre++-0.9.5.tar.gz"
  mirror "https://distfiles.openadk.org/pcre++-0.9.5.tar.gz"
  sha256 "77ee9fc1afe142e4ba2726416239ced66c3add4295ab1e5ed37ca8a9e7bb638a"
  license "LGPL-2.1-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "8229a7705bb8acd30c7dbf142c68d6d53f4af94e68f4456aa4d2a2ab012698b9"
    sha256 cellar: :any,                 arm64_ventura:  "67b2481140ac7c4101d443b54f4d6c7bb7bb1ede6338bae81a4c78509ff49f52"
    sha256 cellar: :any,                 arm64_monterey: "07536c89d8da585a2604dbc109e7cefa2784c83c25b505541b7f407444266f87"
    sha256 cellar: :any,                 arm64_big_sur:  "1232e288cacfd0124da243208e1584caf1925be4dcdcc7b94b96585fb50bfabf"
    sha256 cellar: :any,                 sonoma:         "1e22e67bbade1d70735cb637249c8439a249a95dadc7d48ade1ecf008f85d85d"
    sha256 cellar: :any,                 ventura:        "ce44cf5554199289582744bb08fb4f2361e4d502ead44860aa6442a1381a72ab"
    sha256 cellar: :any,                 monterey:       "9212f378a4e73bd4bfd55a91dcdc54cf9ce589b2abdf35bc1d1201d4ab06cdd1"
    sha256 cellar: :any,                 big_sur:        "0b05be19479fa7181d354dfafc905f874a17c3135170bedfc324fe0873e113c4"
    sha256 cellar: :any,                 catalina:       "15b001d9d01f073cb76772112bc6b3ebac92a3337b19c6dee4eb54d39fe9b6f6"
    sha256 cellar: :any,                 mojave:         "fdaf9cab000ba7b2f7787acd98e53aa3cade6e6536c0c0ec32a010ecade2cb53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02065bd248d60295297eaafbeade3d86245aca27c913c68d0906fee8da4737c3"
  end

  # Last release on 2004-08-25 and it is a wrapper around EOL `pcre`
  disable! date: "2024-02-12", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  # Fix building with libc++. Patch sent to maintainer.
  patch :DATA

  def install
    pcre = Formula["pcre"]
    # Don't install "config.log" into doc/ directory.  "ospack audit" will complain
    # about references to the compiler shims that exist there, and there doesn't
    # seem to be much reason to keep it around
    inreplace "doc/Makefile.am", "../config.log", ""

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-pcre-lib=#{pcre.opt_lib}",
                          "--with-pcre-include=#{pcre.opt_include}",
                          *std_configure_args
    system "make", "install"

    # Pcre++ ships Pcre.3, which causes a conflict with pcre.3 from pcre
    # in case-insensitive file system. Rename it to pcre++.3 to avoid
    # this problem.
    mv man3/"Pcre.3", man3/"pcre++.3"
  end

  def caveats
    <<~EOS
      The man page has been renamed to pcre++.3 to avoid conflicts with
      pcre in case-insensitive file system.  Please use "man pcre++"
      instead.
    EOS
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pcre++.h>
      #include <iostream>

      int main() {
        pcrepp::Pcre reg("[a-z]+ [0-9]+", "i");
        if (!reg.search("abc 512")) {
          std::cerr << "search failed" << std::endl;
          return 1;
        }
        if (reg.search("512 abc")) {
          std::cerr << "search should not have passed" << std::endl;
          return 2;
        }
        return 0;
      }
    CPP
    flags = ["-I#{include}", "-L#{lib}",
             "-I#{Formula["pcre"].opt_include}", "-L#{Formula["pcre"].opt_lib}",
             "-lpcre++", "-lpcre"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_pcrepp", "test.cc", *flags
    system "./test_pcrepp"
  end
end

__END__
diff --git a/libpcre++/pcre++.h b/libpcre++/pcre++.h
index d80b387..21869fc 100644
--- a/libpcre++/pcre++.h
+++ b/libpcre++/pcre++.h
@@ -47,11 +47,11 @@
 #include <map>
 #include <stdexcept>
 #include <iostream>
+#include <clocale>


 extern "C" {
   #include <pcre.h>
-  #include <locale.h>
 }

 namespace pcrepp {

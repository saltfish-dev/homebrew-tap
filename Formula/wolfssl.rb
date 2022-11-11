class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl/archive/refs/tags/v5.5.3-stable.tar.gz"
  sha256 "fd3135b8657d09fb96a8aad16585da850b96ea420ae8ce5ac4d5fdfc614c2683"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-quic
      --enable-sni
      --enable-ip-alt-name
      --enable-altcertchains
      --enable-poly1305
      --enable-chacha
      --enable-sha224
      --enable-sha3
      --enable-blake2
      --enable-blake2s
      --enable-opensslall
      --disable-md5
      --disable-oldtls
      --disable-oldnames
      --disable-benchmark
      --disable-examples
      --disable-crypttests
    ]

    if OS.mac?
      # Extra flag is stated as a needed for the Mac platform.
      # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
      # Also, only applies if fastmath is enabled.
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end

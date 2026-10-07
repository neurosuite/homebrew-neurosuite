class Ndmanager < Formula
  desc "Manager for experimental recording parameters and data processing"
  homepage "https://neurosuite.github.io"
  url "https://github.com/neurosuite/ndmanager/archive/refs/tags/v3.0.0-rc1.tar.gz"
  version "3.0.0-rc1"
  sha256 "487c0695752a1960cf185696dbbf7f6348bb1c9c4e282997836d841f82a16d3a"
  license "GPL-3.0-or-later"
  head "https://github.com/neurosuite/ndmanager.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libneurosuite"
  depends_on "qtbase"

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      The processing tools (filtering, spike extraction, PCA and others) are a separate formula:
        brew install neurosuite/neurosuite/ndmanager-plugins
    EOS
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    assert_match "NDManager 3.0.0", shell_output("#{bin}/ndmanager --version")
  end
end

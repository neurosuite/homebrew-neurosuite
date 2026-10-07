class Klusters < Formula
  desc "Cluster cutting application for spike sorting"
  homepage "https://neurosuite.github.io"
  url "https://github.com/neurosuite/klusters/archive/refs/tags/v3.0.0-rc1.tar.gz"
  version "3.0.0-rc1"
  sha256 "6ea96b48f29809c714253b72c6b86aae3dcf370721ffdb157d9372c09a1ade91"
  license "GPL-3.0-or-later"
  head "https://github.com/neurosuite/klusters.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libneurosuite"
  depends_on "qtbase"

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    assert_match "Klusters 3.0.0", shell_output("#{bin}/klusters --version")
  end
end

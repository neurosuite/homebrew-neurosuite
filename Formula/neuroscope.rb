class Neuroscope < Formula
  desc "Viewer for multichannel electrophysiological and behavioral data"
  homepage "https://neurosuite.github.io"
  url "https://github.com/neurosuite/neuroscope/archive/refs/tags/v3.0.0-rc1.tar.gz"
  version "3.0.0-rc1"
  sha256 "d3b9e8b4db9c51b81a4cc5e7cf78e4c96e05f730b0f5ac3b29ba8f999abda0e1"
  license "GPL-3.0-or-later"
  head "https://github.com/neurosuite/neuroscope.git", branch: "main"

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
    assert_match "NeuroScope 3.0.0", shell_output("#{bin}/neuroscope --version")
  end
end

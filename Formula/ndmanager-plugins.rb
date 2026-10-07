class NdmanagerPlugins < Formula
  include Language::Python::Shebang

  desc "Processing tools and scripts for NDManager (filtering, spike extraction, PCA, LEDs)"
  homepage "https://neurosuite.github.io"
  url "https://github.com/neurosuite/ndmanager-plugins/archive/refs/tags/v3.0.0-rc1.tar.gz"
  version "3.0.0-rc1"
  sha256 "7f3039390aa3cc767cc1ddaf516dd19170b9c1da027525e5f3975bdde244dfcc"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/neurosuite/ndmanager-plugins.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "bash"
  depends_on "ffmpeg"
  depends_on "gawk"
  depends_on "gsl"
  depends_on "libsamplerate"
  depends_on "libxml2"
  depends_on "pyqt"
  depends_on "python@3.14"

  uses_from_macos "libxslt" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DCMAKE_PREFIX_PATH=#{Formula["libxml2"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # The PyQt6 tools must run with the Python that pyqt is installed for.
    rewrite_shebang detected_python_shebang, bin/"ndm_prepare", bin/"ndm_checkconsistency"
  end

  def caveats
    <<~EOS
      The tools are started from NDManager:
        brew install neurosuite/neurosuite/ndmanager
    EOS
  end

  test do
    # A white 8x8 spot moving over a black background, as a stand-in for an LED.
    system Formula["ffmpeg"].opt_bin/"ffmpeg", "-loglevel", "error",
           "-f", "lavfi", "-i", "color=black:s=320x240:r=25:d=2",
           "-f", "lavfi", "-i", "color=white:s=8x8:r=25:d=2",
           "-filter_complex", "[0][1]overlay=x=200:y=150-t*30",
           "-c:v", "mpeg4", "-q:v", "2", "test.avi"
    system bin/"process_extractleds", "-t", "90", "test.avi"
    assert_equal 51, (testpath/"test.spots").read.lines.count
    system Formula["python@3.14"].opt_bin/"python3.14", "-c", "import PyQt6.QtWidgets"
  end
end

class Libneurosuite < Formula
  desc "Library shared by NeuroScope, Klusters and NDManager"
  homepage "https://neurosuite.github.io"
  url "https://github.com/neurosuite/libneurosuite/archive/refs/tags/v3.0.0-rc1.tar.gz"
  version "3.0.0-rc1"
  sha256 "708badd1ec9be4c8880149a12433889316cada1950484dfd441a68301f6aba0d"
  license "GPL-3.0-or-later"
  head "https://github.com/neurosuite/libneurosuite.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qtbase"

  def install
    # The handbook is shown with QTextBrowser, which avoids depending on qtwebengine.
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", "-DWITH_WEBENGINE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Resolve the installed CMake package and its imported library.
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(consumer CXX)
      find_package(neurosuite 3.0 REQUIRED)
      get_target_property(location neurosuite::neurosuite IMPORTED_LOCATION_RELEASE)
      message(STATUS "neurosuite library: ${location}")
    CMAKE
    output = shell_output("cmake -S . -B build -DCMAKE_PREFIX_PATH=#{formula_opt_prefix("qtbase")} 2>&1")
    assert_match %r{neurosuite library: \S+/libneurosuite\.3\S*\.dylib}, output
  end
end

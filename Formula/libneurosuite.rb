class Libneurosuite < Formula
  desc "Library shared by the Neurosuite applications NeuroScope, Klusters and NDManager"
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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(consumer CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(neurosuite 3.0 REQUIRED)
      add_executable(consumer consumer.cpp)
      target_link_libraries(consumer PRIVATE neurosuite::neurosuite)
    CMAKE
    (testpath/"consumer.cpp").write <<~CPP
      #include <QApplication>
      #include <qcolorbutton.h>
      int main(int argc, char **argv) {
        QApplication app(argc, argv);
        QColorButton button;
        return 0;
      }
    CPP
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{Formula["qtbase"].opt_prefix}"
    system "cmake", "--build", "build"
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    system "./build/consumer"
  end
end

class Ydk < Formula
  desc "generate API bindings to YANG data models"
  homepage "https://github.com/CiscoDevNet/ydk-cpp"
  url "https://github.com/CiscoDevNet/ydk-cpp/archive/0.5.3.tar.gz"
  sha256 "dd870f664d4c90e869885bc48dcdc1e1bd7508eb0fa80d357ea3355154dfe939"

  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "libssh"
  depends_on "pcre"
  depends_on "xml2"
  depends_on "pkg-config" => :build

  def install
    mkdir "core/ydk/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ydk/path_api.hpp>
      int main() {
        ydk::path::Repository repo{};
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-Wall", "-Wextra", "-g", "-O0",
    "test.cpp", "-otest", "-lxml2", "-lcurl",
    "-lssh_threads", "-lpcre", "-lxslt", "-lssh", "-lpthread", "-ldl",
    "-lydk"
    system "./test"
  end
end

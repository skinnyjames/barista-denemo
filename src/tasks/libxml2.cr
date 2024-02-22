@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libxml2 < Barista::Task
  include Common::TaskHelpers

  @@name = "libxml2"

  dependency Zlib
  dependency Libiconv
  dependency Liblzma

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    cmd = [
      "./configure",
      "--prefix=#{install_dir}/embedded",
      "--with-zlib=#{install_dir}/embedded",
      "--with-iconv=#{install_dir}/embedded",
      "--with-lzma=#{install_dir}/embedded",
      "--with-sax1", # required for nokogiri to compile
      "--without-python",
      "--without-icu"
    ]


    command(cmd.join(" "), env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure :  Nil
    license("MIT")
    license_file("Copyright")
    version("2.10.3")
    source("https://download.gnome.org/sources/libxml2/2.10/libxml2-#{version}.tar.xz", 
      sha256: "5d2cc3d78bec3dbe212a9d7fa629ada25a7da928af432c93060ff5c17ee28a9c")

    project.exclude("embedded/lib/xml2Conf.sh")
    project.exclude("embedded/bin/cmake/libxml2/libxml2-config.cmake")
  end
end
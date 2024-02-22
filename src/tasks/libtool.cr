@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libtool < Barista::Task
  include Common::TaskHelpers

  @@name = "libtool"

  dependency ConfigGuess

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    update_config_guess
    update_config_guess(target: "libltdl/config")

    command("./configure --prefix=#{install_dir}/embedded", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure : Nil
    license("GPL-2.0")
    version("2.4.6")
    source("https://ftp.gnu.org/gnu/libtool/libtool-#{version}.tar.gz",
      sha256: "e3bd4d5d3d025a36c21dd6af7ea818a2afcd4dfc1ea5a17b39d7854bcd0c06e3")

    project.exclude("embedded/share/libtool")
    project.exclude("embedded/bin/libtool")
    project.exclude("embedded/bin/libtoolize")
  end
end

@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Librsvg < Barista::Task
  include Common::TaskHelpers

  @@name = "librsvg"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    command("./autogen.sh --prefix=#{install_dir}/embedded", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure : Nil
		version("2.57.1")
		source("https://github.com/GNOME/librsvg/archive/refs/tags/#{version}.tar.gz")
		license("LGPLv2.1")
		license_file("COPYING.LIB")
  end
end

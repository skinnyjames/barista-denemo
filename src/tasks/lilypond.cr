require "./gtk/glib.cr"

@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Lilypond < Barista::Task
  include Common::TaskHelpers

	dependency Libpng
	dependency Glib
	dependency Guile

  @@name = "lilypond"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		command("meson setup --prefix=#{install_dir}/embedded build", env: env)
		command("ninja -C build", env: env)
  end

  def configure :  Nil
    version("3.3.0")
    license("GPLv2")
    license_file("COPYING")
    source("https://github.com/breakfastquay/rubberband/archive/refs/tags/v#{version}.tar.gz")
  end
end
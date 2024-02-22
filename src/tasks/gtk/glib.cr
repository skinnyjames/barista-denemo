@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Glib < Barista::Task
  include Common::TaskHelpers

  @@name = "glib"

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		# env["LDFLAGS"] += " -pthread"
		sync_source

		command("meson setup --prefix=#{install_dir}/embedded _build", env: env)
		command("meson -Dc_args=\"-lpthread\" _build ", env: env)
		# command("meson install -C _build", env: env)

		# command("./configure --prefix=#{install_dir}/embedded", env: env)
		# command("make", env: env)
		# command("make install", env: env)
	end

	def configure : Nil
		version("2.79.0")
		source("https://download.gnome.org/sources/glib/2.79/glib-2.79.0.tar.xz")
		license("GPLv2")
		license_file("COPYING")
	end
end

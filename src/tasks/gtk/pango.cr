# @[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Pango < Barista::Task
  include Common::TaskHelpers

  @@name = "pango"

	dependency Glib

	def build : Nil
		return unless build_gtk?

		env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		sync_source

		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make install", env: env)
	end

	def configure : Nil
		version("2.9.6")
		source("https://download.gnome.org/sources/glib/2.9/glib-2.9.6.tar.gz", 
			sha256: "cc8c30451df140daffeae6ffba53620c8d39773dbed795fbcf5b64cdd52c71f8")
		license("LGPLv2.1")
		license_file("COPYING")
	end
end

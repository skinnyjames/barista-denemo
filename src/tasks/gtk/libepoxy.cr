# @[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libepoxy < Barista::Task
  include Common::TaskHelpers

  @@name = "pango"

	def build : Nil
		return unless build_gtk?
	end

	def configure : Nil
		version("2.9.6")
		source("https://download.gnome.org/sources/glib/2.9/glib-2.9.6.tar.gz", 
			sha256: "cc8c30451df140daffeae6ffba53620c8d39773dbed795fbcf5b64cdd52c71f8")
		license("LGPLv2.1")
		license_file("COPYING")
	end
end

@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libunistring < Barista::Task
  include Common::TaskHelpers

  @@name = "libunistring"

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		sync_source

		command("./configure --prefix=#{install_dir}/embedded")
		command("make", env: env)
		command("make install", env: env)
	end

	def configure : Nil
		version("1.1")
		source("https://ftp.gnu.org/gnu/libunistring/libunistring-#{version}.tar.gz")
		license("GPLv3")
		license_file("COPYING")
		license_file("COPYING.LIB")
	end
end
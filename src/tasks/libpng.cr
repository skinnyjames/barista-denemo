@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libpng < Barista::Task
  include Common::TaskHelpers

	@@name = "libpng"

	dependency Zlib

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		command("./configure --prefix=#{install_dir}/embedded --with-zlib=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make install", env: env)
	end

	def configure :  Nil
		version("1.6.39")
		license("Libpng")
		license_file("LICENSE")
		source("https://sourceforge.net/projects/libpng/files/libpng16/#{version}/libpng-#{version}.tar.gz/download", extension: ".tar.gz")
	end
end
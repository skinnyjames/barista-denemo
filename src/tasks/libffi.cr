@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libffi < Barista::Task
  include Common::TaskHelpers

  @@name = "libffi"

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		# command("./autogen.sh", env: env)
		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make install", env: env)
	end

	def configure : Nil
		version("3.4.4")
		source("https://github.com/libffi/libffi/releases/download/v#{version}/libffi-#{version}.tar.gz")
		license("libffi")
		license_file("LICENSE")
	end
end

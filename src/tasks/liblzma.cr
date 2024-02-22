@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Liblzma < Barista::Task
  include Common::TaskHelpers

	@@name = "liblzma"

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		command(config_command.join(" "), env: env)
		command("make install", env: env)
	end

	def config_command
		[
			"./configure",
			"--prefix=#{install_dir}/embedded",
			"--disable-debug",
			"--disable-dependency-tracking",
			"--disable-doc",
			"--disable-scripts"
		]
	end

	def configure :  Nil
		version("5.2.4")
		license("Public-Domain")
		license_file("COPYING")
		source("http://tukaani.org/xz/xz-#{version}.tar.gz",
			sha256: "b512f3b726d3b37b6dc4c8570e137b9311e7552e8ccbab4d39d47ce5f4177145")
	end
end
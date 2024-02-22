@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libgc < Barista::Task
  include Common::TaskHelpers

  @@name = "libgc"

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		# clone gitatomic ops into source dir
		# command("git clone https://github.com/ivmai/libatomic_ops")

		command("autoreconf -vif", env: env)
		command("automake --add-missing", env: env)
		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make install", env: env)
	end

	def configure : Nil
		version("8.2.4")
		source("https://www.hboehm.info/gc/gc_source/gc-#{version}.tar.gz")
		license("MIT-Style")
		license_file("AUTHORS")
	end
end

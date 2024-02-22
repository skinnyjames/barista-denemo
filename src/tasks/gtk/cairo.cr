# @[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Cairo < Barista::Task
  include Common::TaskHelpers

  @@name = "cairo"

	dependency Pango

	def build : Nil
		return unless build_gtk?

		env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		sync_source

		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make install", env: env)
	end

	def configure : Nil
	end
end

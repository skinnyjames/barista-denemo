@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Aubio < Barista::Task
  include Common::TaskHelpers

  @@name = "aubio"

	dependency Guile
	dependency Aubio


  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		sync_source

		command("./scripts/get_waf.sh", env: env)

		# Note (windows just calls `waf` without the `./`)
		command("./waf configure --prefix=#{install_dir}")
		command("./waf build")
		command("./waf install")
  end

  def configure : Nil
		version("0.4.9")
		source("https://github.com/aubio/aubio/archive/refs/tags/#{version}.tar.gz")
		license("GPLv3")
		license_file("COPYING")
  end
end

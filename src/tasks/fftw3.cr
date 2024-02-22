@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Fftw3 < Barista::Task
  include Common::TaskHelpers

  @@name = "fftw3"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		
		sync_source

		command("./configure --prefix=#{install_dir}/embedded")
		command("make")
		command("make install")
  end

  def configure : Nil
    version("3.3.10")
		source("http://fftw.org/fftw-#{version}.tar.gz", md5: "8ccbf6a5ea78a16dbc3e1306e234cc5c")
		license("GPLv2")
		license_file("COPYING")
  end
end

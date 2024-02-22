@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Portaudio < Barista::Task
  include Common::TaskHelpers

  @@name = "portaudio"

	# NOTE: Linux builds might need a dependency on ALSA
	# https://portaudio.com/docs/v19-doxydocs/compile_linux.html
  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		command("./configure --prefix=#{install_dir}/embedded")
		command("make")
		command("make install")
  end

	# Note the current published release fails to build on macosx. pulling latest
  def configure : Nil
    version("latest")
		source("https://github.com/PortAudio/portaudio/tarball/master", extension: ".tar.gz")
		license("PortAudio")
		license_file("LICENSE.txt")
  end
end

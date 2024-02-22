require "./gtk/glib.cr"

@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Fluidsynth < Barista::Task
  include Common::TaskHelpers

  @@name = "fluidsynth"

	dependency Glib
	dependency Portaudio

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		command("mkdir build", env: env)
		command("cmake -DCMAKE_INSTALL_PREFIX=#{install_dir}/embedded -Denable-portaudio=1 ..", chdir: "#{source_dir}/build", env: env)
		command("make", chdir: "#{source_dir}/build", env: env)
		command("make install", chdir: "#{source_dir}/build", env: env)
  end

  def configure : Nil
    version("2.3.4")
		source("https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v#{version}.tar.gz")
		license("LGPLv2.1")
		license_file("LICENSE")
  end
end

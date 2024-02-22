@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Portmidi < Barista::Task
  include Common::TaskHelpers

  @@name = "portmidi"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		command("mkdir build", env: env)
		command("cmake -DCMAKE_INSTALL_PREFIX=#{install_dir}/embedded ..", chdir: "#{source_dir}/build", env: env)
		command("make", chdir: "#{source_dir}/build", env: env)
		command("make install", chdir: "#{source_dir}/build", env: env)
  end

  def configure :  Nil
    version("2.0.4")
    license("PortMidi")
    license_file("license.txt")
    source("https://github.com/PortMidi/portmidi/archive/refs/tags/v#{version}.tar.gz")
  end
end
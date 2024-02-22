@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Gettext < Barista::Task
  include Common::TaskHelpers

  @@name = "gettext"

  dependency ConfigGuess

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		sync_source

		command("./configure --prefix=#{install_dir}", env: env)
		command("make", env: env)
		command("make install", env: env)
  end

  def configure :  Nil
    version("0.22.4")
    license("GPLv3")
    license_file("COPYING")
    source("https://ftp.gnu.org/pub/gnu/gettext/gettext-#{version}.tar.gz")
  end
end
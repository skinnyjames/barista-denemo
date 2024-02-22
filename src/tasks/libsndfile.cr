@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libsndfile < Barista::Task
  include Common::TaskHelpers

  @@name = "libsndfile"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		
		command("autoreconf -vif", env: env)
		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make check", env: env)
  end

  def configure :  Nil
    version("1.2.2")
    license("LGPLv2")
    license_file("COPYING")
    source("https://github.com/libsndfile/libsndfile/archive/refs/tags/#{version}.tar.gz")
  end
end
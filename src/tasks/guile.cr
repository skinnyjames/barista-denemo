@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Guile < Barista::Task
  include Common::TaskHelpers

  @@name = "guile"

	dependency Libffi
	dependency Libgc
	dependency Libgmp
	dependency Libiconv
	dependency Gettext
	dependency Libtool
	dependency Libunistring

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
		mkdir("#{smart_install_dir}/embedded/lib", parents: true)

		command("./configure #{configure_flags}", env: env)
		command("make", env: env)
		command("make install", env: env)
  end

	def configure_flags : String
		String.build do |io|
			io << "--with-libgmp-prefix=#{install_dir}/embedded"
			io << " --with-libiconv-prefix=#{install_dir}/embedded"
			io << " --with-libintl-prefix=#{install_dir}/embedded"
			io << " --with-libtdl-prefix=#{install_dir}/embedded"
			io << " --with-libunistring-prefix=#{install_dir}/embedded"
			io << " --with-libgc-prefix=#{install_dir}/embedded"
			io << " --with-libffi-prefix=#{install_dir}/embedded"
			io << " --prefix=#{install_dir}/embedded"
		end
	end

  def configure : Nil
    version("3.0.9")
		source("https://ftp.gnu.org/gnu/guile/guile-#{version}.tar.gz")
    license("LGPLv3")
    license_file("LICENSE")
		license_file("COPYING")
		license_file("COPYING.LESSER")
  end
end

@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Libgmp < Barista::Task
  include Common::TaskHelpers

	# NOTE: libgmp has blocked Microsoft/GitHub servers 
	# due to being DDOS'ed
	# https://gmplib.org/
	# Any CI builds will need to use a mirror instead.
	dependency ConfigGuess
  @@name = "libgmp"

	def build : Nil
		env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		# need to use old linker for xcode 15 on mac
		# https://www.mail-archive.com/gmp-bugs@gmplib.org/msg01497.html
		env["LDFLAGS"] += " -ld64" if macos?
		update_config_guess
		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make check", env: env)
		command("make install", env: env)
	end

	def configure : Nil
		version("6.3.0")
		source("https://ftp.gnu.org/gnu/gmp/gmp-#{version}.tar.xz")
		license("LGPLv3")
		license_file("COPYING.LESSERv3")
	end
end

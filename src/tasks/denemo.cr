@[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Denemo < Barista::Task
  include Common::TaskHelpers

	file("icon", "#{__DIR__}/../images/icon.png")

  @@name = "denemo"

	dependency Guile
	dependency Aubio
	dependency Portaudio
	dependency Fftw3
	# dependency Gtk3
	dependency Fluidsynth
	dependency Librsvg
	dependency Portmidi
	dependency Libsndfile
	# dependency Atril
	dependency Rubberband
	dependency Lilypond

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		command("./configure --prefix=#{install_dir}/embedded", env: env)
		command("make", env: env)
		command("make install", env: env)

		if macos?
			make_macos_desktop_app_file
		end
  end

	def make_macos_desktop_app_file
    mkdir("#{smart_install_dir}/embedded/resources/Denemo.app/Contents/MacOS", parents: true)
    mkdir("#{smart_install_dir}/embedded/resources/Denemo.app/Contents/Resources", parents: true)

    block do
      script = <<-EOF
      #!/usr/bin/env bash
                         
                        
      ./#{install_dir}/embedded/bin/denemo
      EOF

      File.write("#{smart_install_dir}/embedded/resources/Denemo.app/Contents/MacOS/Denemo", script)
    end
    command("chmod 755 \"#{smart_install_dir}/embedded/resources/Denemo.app/Contents/MacOS/Denemo\"")

    # make iconset
    block do
			File.write("#{smart_install_dir}/embedded/icon.png", file("icon"))
      icon = File.join(smart_install_dir, "embedded", "icon.png")
      icondir = "#{smart_install_dir}/embedded/resources/Denemo.app/Contents/Resources/Denemo.iconset"
      
      mkdir(icondir, parents: true).execute

      # regular
      [16, 32, 128, 256, 512].each do |size|
        command("sips -z #{size} #{size} #{icon} --out \"#{icondir}/icon_#{size}x#{size}.png\"").execute
      end

      # retina
      [32, 64, 256, 512].each do |size|
        command("sips -z #{size} #{size} #{icon} --out \"#{icondir}/icon_#{(size / 2).to_i32}x#{(size / 2).to_i32}@2x.png\"").execute
      end

      command("iconutil -c icns -o \"Denemo.app/Contents/Resources/Denemo.icns\"  \"#{icondir}\"", chdir: "#{smart_install_dir}/embedded/resources").execute
      command("rm -Rf \"#{icondir}\"").execute
    end

    # write plist
    block do
      plist = <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleIconFile</key>
        <string>Denemo</string>
      </dict>
      </plist>
      EOF

      File.write("#{smart_install_dir}/embedded/resources/Denemo.app/Contents/info.plist", plist)
    end
  end


  def configure : Nil
    version("r2.6.0")
		source("https://github.com/denemo/denemo/archive/refs/tags/#{version}.tar.gz")
		license("GPLv3")
		license_file("COPYING")
  end
end

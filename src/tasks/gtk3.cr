require "./gtk/*"

# @[Barista::BelongsTo(DenemoBuilder)]
class Tasks::Gtk3 < Barista::Task
  include Common::TaskHelpers

  @@name = "gtk3"

	# deps will cascade
	dependency Atk

	# Build deps
	# In order to build GTK you will need:

	# a C99 compatible compiler
	# Python 3
	# Meson
	# Ninja
	
	# You will also need various dependencies, based on the platform you are
	# building for:
	
	# GLib
	# GdkPixbuf
	# GObject-Introspection
	# Cairo
	# Pango
	# Epoxy
	# Graphene
	# Xkb-common
	
	# If you are building the Wayland backend, you will also need:
	
	# Wayland-client
	# Wayland-protocols
	# Wayland-cursor
	# Wayland-EGL
	
	# If you are building the X11 backend, you will also need:
	
	# Xlib, and the following X extensions:
	
	# xrandr
	# xrender
	# xi
	# xext
	# xfixes
	# xcursor
	# xdamage
	# xcomposite

  def build : Nil
		return unless build_gtk?

    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

		sync_source

		command("./configure --prefix=#{install_dir}/embedded")
		command("make")
		command("make install")
  end

  def configure : Nil
    version("4.12.5")
		source("https://gitlab.gnome.org/GNOME/gtk/-/archive/#{version}/gtk-#{version}.tar.gz")
		license("GPLv2")
		license_file("COPYING")
  end
end

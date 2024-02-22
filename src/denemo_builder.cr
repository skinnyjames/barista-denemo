require "barista"
require "./common/task_helpers"
require "./cli/build"

class DenemoBuilder < Barista::Project
  include Barista::Behaviors::Omnibus::Project

  VERSION = "0.1.0"

  getter :colors

  @@name = "denemo"
  @colors : Barista::ColorIterator = Barista::ColorIterator.new

  def initialize
    install_dir("/opt/denemo")
    barista_dir("/opt/barista-denemo")
    build_version("0.1.0")
    package_user("root")
    package_group("root")
    maintainer("Zero Stars <zero@skinnyjames.net>")
    homepage("https://denemo.org")
    license("Private")
    description("Denemo is a free music notation program for GNU/Linux, Mac OSX and Windows that lets you rapidly enter notation which it typesets using the LilyPond music engraver.")
    package_name("denemo")

    {% if flag?(:darwin) %}
      package_scripts_path("#{__DIR__}/scripts/macosx")
    {% else %}
      package_scripts_path("#{__DIR__}/scripts/linux")
    {% end %}
  end

  def build(workers : Int32, *, clean_existing : Bool, without_gtk : Bool)
    clean! if clean_existing
    workspace = ENV["GITHUB_WORKSPACE"]? || "/opt"
    barista_dir("#{workspace}/barista-denemo")

    callbacks = setup_cache
    tasks.each do |klass|
      logger = Barista::RichLogger.new(colors.next, klass.name)
      task = klass.new(self, callbacks, without_gtk: without_gtk)

      task.on_output { |str| logger.debug { str } }
      task.on_error { |str| logger.error { str } }
    end

    Log.setup_from_env

    orchestration = orchestrator(workers: workers)

    orchestration.on_task_start do |task|
      Barista::Log.info(task) { "starting build" }
    end

    orchestration.on_task_failed do |task, ex|
      Barista::Log.error(task) { "build failed: #{ex}" }
    end

    orchestration.on_task_succeed do |task|
      Barista::Log.info(task) { "build succeeded" }
    end

    orchestration.on_unblocked do |info|
      Barista::Log.info(name) { "Unblocked info: #{info}" }
    end

    orchestration.execute

    packager
      .on_output { |str| puts str }
      .on_error { |str| puts str }
      .run
  end

  def console_application
    app = previous_def
    app.add(Cli::Build.new(self))
    app
  end

  def setup_cache : Barista::Behaviors::Omnibus::CacheCallbacks
    if ENV["USE_CACHE"]? == "true" || !ENV["CI"]?
      cache(true)

      prefix = [
        "denemo",
        platform.family,
        kernel.machine.gsub(/\s/, "_")
      ].join("-")

      cache_tag_prefix(prefix)
    end

    workspace = ENV["GITHUB_WORKSPACE"]? || "/opt"

    callbacks = Barista::Behaviors::Omnibus::CacheCallbacks.new
    callbacks.fetch do |cacher|
      dir = "#{Dir.tempdir}/denemo"
      FileUtils.mkdir_p(dir)
      FileUtils.mkdir_p("#{workspace}/barista-cache/denemo")
      cache_path = File.join("#{workspace}/barista-cache", "denemo", cacher.filename)
      begin
        if File.exists?(cache_path)
          FileUtils.cp_r(cache_path, dir)
          cacher.unpack(File.join(dir, cacher.filename))
        else
          puts "File #{cache_path} does not exist"
          false
        end
      rescue ex
        puts "Exception on cache retrieval: #{ex}"
        false
      end
    end

    callbacks.update do |task, path|
      begin
        cache_path = File.join("#{workspace}/barista-cache", "denemo", "#{task.tag}.tar.gz")
        FileUtils.mkdir_p("#{workspace}/barista-cache/denemo") unless Dir.exists?("#{workspace}/barista-cache/denemo")
        FileUtils.cp(path, cache_path)
        File.chmod(cache_path, 0o755)
        true
      rescue ex
        puts "Exception on updating cache: #{ex}"
        false
      end
    end

    callbacks
  end
end

require "./tasks/*"
DenemoBuilder.new.console_application.run
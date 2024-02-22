@[ACONA::AsCommand("build")]
class Cli::Build < ACON::Command
  include Barista::Behaviors::Software::OS::Information

  # @@default_name = "build"

  getter :project

  def initialize(@project : DenemoBuilder)
    super()
  end

  protected def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    workers = input.option("workers", Int32?) || available_cpus
    clean = input.option("clean", Bool?) || false
    without_gtk = input.option("x-gtk", Bool?) || true

    begin
      project.build(workers, clean_existing: clean, without_gtk: without_gtk)
      ACON::Command::Status::SUCCESS
    rescue ex
      output.puts("<error>Build failed: #{ex.message}</error>")
      ACON::Command::Status::FAILURE
    end

  end

  protected def configure : Nil
    self
      .description("Builds a Denemo package")
      .option("workers", "w", :optional, "The number of concurrent build workers to use (default #{available_cpus})")
      .option("clean", "c", :none, "Cleans current install before building")
      .option("x-gtk", "x", :none, "Builds without GTK")
  end

  private def available_cpus
    memory.cpus.try(&.-(1)) || 1
  end
end

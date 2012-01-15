describe "git-autobisect" do
  def run(command)
    result = `#{command}`
    raise "FAILED #{result} [#{command}]" unless $?.success?
    result
  end

  def autobisect(args)
    run "./git-autobisect.sh #{args}"
  end

  describe "basics" do
    it "shows its usage without arguments" do
      autobisect("").should include("Usage")
    end

    it "shows its usage with -h" do
      autobisect("-h").should include("Usage")
    end

    it "shows its usage with --help" do
      autobisect("--help").should include("Usage")
    end

    it "shows its version with -v" do
      autobisect("-v").should =~ /^git-autobisect \d+\.\d+\.\d+$/
    end

    it "shows its version with --version" do
      autobisect("-v").should =~ /^git-autobisect \d+\.\d+\.\d+$/
    end
  end

  describe "bisecting" do
    
  end
end
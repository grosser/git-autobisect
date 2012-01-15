describe "git-autobisect" do
  def run(command)
    result = `#{command}`
    raise "FAILED #{result} [#{command}]" unless $?.success?
    result
  end

  def autobisect(args)
    run "./git-autobisect.sh #{args}"
  end

  it "shows its usage without arguments" do
    autobisect("").should include("Usage")
  end
end
ROOT = File.expand_path('../../', __FILE__)

describe "git-autobisect" do
  def run(command, options={})
    result = `#{command} 2>&1`
    message = (options[:fail] ? "SUCCESS BUT SHOULD FAIL" : "FAIL")
    raise "[#{message}] #{result} [#{command}]" if $?.success? == !!options[:fail]
    result
  end

  def autobisect(args, options={})
    run "#{ROOT}/git-autobisect.sh #{args}", options
  end

  def current_commit
    run "git log --oneline | head -1"
  end

  before do
    Dir.chdir ROOT
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
    before do
      run "rm -rf spec/tmp ; mkdir spec/tmp"
      Dir.chdir "spec/tmp"
      run "git init && touch a && git add a && git commit -m 'added a'"
    end

    it "stops when the first commit works" do
      autobisect("test 1", :fail => true).should include("current commit is not broken")
    end

    it "stops when no commit works" do
      autobisect("test", :fail => true).should include("no commit works")
    end

    it "finds the first broken commit for 1 commit" do
      run "git rm a && git commit -m 'remove a'"
      result = autobisect("test -e a")
      result.should include("bisect run success")
      result.should =~ /is the first bad commit.*remove a/m
    end

    it "stays at the first broken commit" do
      run "git rm a && git commit -m 'remove a'"
      autobisect("test -e a")
      pending "git bisect randomly stops at a commit" do
        current_commit.should include("remove a")
      end
    end

    it "finds the first broken commit for n commits" do
      run "git rm a && git commit -m 'remove a'"
      run "touch b && git add b && git commit -m 'added b'"
      run "touch c && git add c && git commit -m 'added c'"
      result = autobisect("test -e a")
      result.should include("bisect run success")
      result.should =~ /is the first bad commit.*remove a/m
      current_commit.should include("remove a")
    end
  end
end
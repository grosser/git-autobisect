ROOT = File.expand_path('../../', __FILE__)

describe "git-autobisect" do
  def run(command, options={})
    result = `#{command} 2>&1`
    message = (options[:fail] ? "SUCCESS BUT SHOULD FAIL" : "FAIL")
    raise "[#{message}] #{result} [#{command}]" if $?.success? == !!options[:fail]
    result
  end

  def autobisect(args, options={})
    run "#{ROOT}/bin/git-autobisect #{args}", options
  end

  def current_commit
    run "git log --oneline | head -1"
  end

  def add_irrelevant_commit(name="b")
    run "echo #{rand} >> #{name} && git add #{name} && git commit -m 'added #{name}'"
  end

  def remove_a
    run "git rm a && git commit -m 'remove a'"
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
      autobisect("'test 1'", :fail => true).should include("HEAD is not broken")
    end

    it "stops when no commit works" do
      autobisect("test", :fail => true).should include("No good commit found")
    end

    it "finds the first broken commit for 1 commit" do
      remove_a
      result = autobisect("'test -e a'")
      result.should_not include("bisect run")
      result.should =~ /is the first bad commit.*remove a/m
    end

    it "finds the first broken commit for multiple commits" do
      remove_a
      result = autobisect("'test -e a'")
      result.should_not include("bisect run success")
      result.should =~ /is the first bad commit.*remove a/m
    end

    it "can run a complex command" do
      10.times{ add_irrelevant_commit }
      remove_a
      10.times{ add_irrelevant_commit }
      result = autobisect("'sleep 0.01 && test -e a'")
      result.should include("bisect run success")
      result.should =~ /is the first bad commit.*remove a/m
    end

    it "is fast for a large number of commits" do
      # build a ton of commits
      40.times do |i|
        add_irrelevant_commit("#{i}_good")
      end
      run "git rm a && git commit -m 'remove a'"
      40.times do |i|
        add_irrelevant_commit("#{i}_bad")
      end

      # ran successful ?
      result = autobisect("'echo a >> count && test -e a'")
      result.should include("bisect run success")
      result.should =~ /is the first bad commit.*remove a/m

      # ran fast?
      File.read('count').count('a').should < 20
    end

    it "stays at the first broken commit" do
      remove_a
      autobisect("'test -e a'")
      current_commit.should include("remove a")
    end

    context "with multiple good commits after broken commit" do
      before do
        add_irrelevant_commit "b"
        add_irrelevant_commit "c"
        add_irrelevant_commit "d"
        add_irrelevant_commit "e" # first good
        remove_a
        add_irrelevant_commit "f" # last bad
        add_irrelevant_commit "g"
      end

      it "finds the first broken commit for n commits" do
        result = autobisect("'test -e a'")
        result.should include("bisect run success")
        result.should =~ /is the first bad commit.*remove a/m
        current_commit.should include("remove a")
      end

      it "does not run test too often" do
        result = autobisect("'echo a >> count && test -e a'")
        result.should include("bisect run success")
        result.should include("added e")
        File.read('count').count('a').should == 5
      end
    end
  end
end

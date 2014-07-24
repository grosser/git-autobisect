require "git/autobisect/version"

module Git
  module Autobisect
    class << self
      def cli(argv)
        options = extract_options(argv)

        command = argv.first
        if command.to_s.empty?
          puts "Usage instructions: git-autobisect --help"
          return 1
        end

        # make sure bundle is fresh before each run
        if !options[:no_bundle] && File.exist?("Gemfile")
          command = "(bundle check || (test -f vendor/cache && bundle --local --quiet) || bundle --quiet) && (#{command})"
        end

        # reset changes but keep the exit status
        command += "; export X=$? ; git reset --hard ; exit $X"

        run_command(command, options) || 0
      end

      def run_command(command, options)
        commits = `git log --pretty=format:'%h' | head -n #{options[:max]}`.split("\n")
        good, bad = find_good_and_bad_commit(commits, command, options)

        if good == commits.first
          puts " ---> HEAD is not broken"
          return 1
        elsif not good
          puts " ---> No good commit found before HEAD~#{options[:max]}"
          return 1
        end

        if exact_commit_known?(commits, good, bad)
          # return same result as git bisect
          run! "git checkout #{bad}"
          puts "#{bad} is the first bad commit"
          puts `git show #{bad}`
        else
          first_bad = bisect_to_exact_match(command, good, bad)
          run! "git checkout #{first_bad}"
        end
      end

      private

      def extract_options(argv)
        options = {
          :max => 1000
        }
        OptionParser.new do |opts|
          opts.banner = <<-BANNER.gsub(" "*12, "")
            Find the commit that broke the build

            Usage:
                git-autobisect 'ruby test/foo_test.rb -n "/xxx/"' [options]

            Options:
          BANNER
          opts.on("-h", "--help", "Show this.") { puts opts; exit }
          opts.on("-v", "--version", "Show Version"){ puts "git-autobisect #{Version}"; exit }
          opts.on("-m", "--max N", Integer, "Inspect commits between HEAD..HEAD~<max>"){|max| options[:max] = max }
          opts.on("-s", "--start N", Integer, "Use N (instead of 1) as initial step and keep multiplying by 2"){|start| options[:start] = start }
          opts.on("--step N", Integer, "Use N as step (instead of multiplying by 2)"){|step| options[:step] = step }
          opts.on("--no-bundle", "Do not bundle even if a Gemfile exists"){ options[:no_bundle] = true }
        end.parse!(argv)
        options
      end

      def run(cmd)
        all = ""
        puts cmd
        IO.popen(cmd) do |pipe|
          while str = pipe.gets
            all << str
            puts str
          end
        end
        [$?.success?, all]
      end

      def run!(command)
        raise "Command failed #{command}" unless run(command).first
      end

      def find_good_and_bad_commit(commits, command, options)
        initial = 1
        i = options[:start] || initial
        step = options[:step]
        maybe_good = commits.first

        loop do
          # scan backwards through commits to find a good
          offset = [i - 1, commits.size-1].min
          maybe_good, bad = commits[offset], maybe_good
          return if i > initial and bad == maybe_good # we reached the end

          # see if it works
          puts " ---> Now trying #{maybe_good} (HEAD~#{offset})"
          run!("git checkout #{maybe_good}")
          return [maybe_good, bad] if run(command).first
          step ? i += step : i *= 2
        end
      end

      def bisect_to_exact_match(command, good, bad)
        run! "git bisect reset"
        run! "git bisect start #{bad} #{good}"
        success, output = run("git bisect run sh -c '#{command}'")
        raise "error while bisecting" unless success
        output.match(/([\da-f]+) is the first bad commit/)[1]
      end

      def exact_commit_known?(commits, good, bad)
        (commits.index(good) - commits.index(bad)).abs <= 1
      end
    end
  end
end

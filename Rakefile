require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'rubinjam/tasks'

task :default do
  sh "rspec spec/"
end

# update Readme.md to point to latest release
(class << Bump::Bump;self;end).send(:prepend, Module.new do
  def run(*)
    result = super

    file = 'Readme.md'
    content = File.read(file)
    content.sub!(/releases\/download\/[^\/]+/, "releases/download/v#{Bump::Bump.current}") ||
      abort("Readme change failed")
    File.write(file, content)
    system("git add #{file} && git commit --amend --no-edit") || abort("Unable to commit")

    result
  end
end)

task release: 'rubinjam:upload_binary'

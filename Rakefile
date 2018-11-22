require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'rubinjam/tasks'

task :default do
  sh "rspec spec/"
end

# release a static binary and link it from the readme
task release: 'rubinjam:upload_binary'
Bump.replace_in_default = ["Readme.md"]

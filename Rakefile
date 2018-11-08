require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'json'

task :default do
  sh "rspec spec/"
end

# update Readme.md to point to latest release
(class << Bump::Bump;self;end).prepend(Module.new do
  def run(*)
    result = super

    file = 'Readme.md'
    content = File.read(file)
    content.sub!(/releases\/download\/[^\/]+/, "releases/download/#{Bump::Bump.current}") ||
      abort("Readme change failed")
    File.write(file, content)
    system("git add #{file} && git commit --amend --no-edit") || abort("Unable to commit")

    result
  end
end)

# will run after the actual release task from bundler/gem_tasks
task release: :upload_binary

task :upload_binary  do
  # find token for auth
  github_token = `git config github.token`.strip
  abort "Need github.token" if github_token.empty?
  auth = ["-H", "Authorization: token #{github_token}"]

  # find current tag
  tag = `git describe --tags --exact-match`.strip
  abort "Need to be on exact tag" if tag.empty?

  # create release
  reply = IO.popen(["curl", *auth, "--data", {tag_name: tag}.to_json, "https://api.github.com/repos/grosser/git-autobisect/releases"]).read
  id = JSON.parse(reply).fetch("id") # fails when release already exists

  # upload binary
  sh "rubinjam"
  sh(
    "curl",
    "-X", "POST",
    "--data-binary", "@git-autobisect",
    "-H", "Content-Type: application/octet-stream",
    *auth,
    "https://uploads.github.com/repos/grosser/git-autobisect/releases/#{id}/assets?name=git-autobisect"
  )
ensure
  sh "rm", "-f", "git-autobisect"
end

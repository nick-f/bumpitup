#!/usr/bin/env ruby

if ARGV.size == 0
  $stderr.puts <<-TXT
    Usage:
    bumpitup <gem_name> <repo_name> [<repo_name>...]
    Example: dep-bump awesome_gem first_repo second_repo
    This will bump 'awesome_gem' in both first_repo and second_repo, and open PRs for both.
  TXT
  exit 1
end

@gem_name = ARGV[0]
@repos = ARGV[1..-1]

def sh(cmd, store = nil)
  puts cmd
  IO.popen(cmd) do |pipe|
    while str = pipe.gets
      puts str
    end
  end
  $?.success?
end

def gem_version
  version = `bundle show #{@gem_name}`
  version.split('-').last.chomp
end

def base_dir
  ENV['BIU_BASE_DIR'] || ENV['HOME']
end

def commit_message
  "Bump #{@gem_name} to #{gem_version}"
end

def github_compare_url
  homepage_url = `bundle info #{@gem_name} | grep Homepage`

  github_url = github_url?(homepage_url)

  if github_url
    "#{github_url}/compare/v#{@old_version}...v#{gem_version}"
  end
end

def github_url?(url)
  url[/(https:\/\/w*.?github.com\/\S+\/\S+)/]
end

def pr_message
  <<-PR
#{commit_message}

### Description

#{@gem_name} was outdated. Bumping to #{gem_version}

    bundle update #{@gem_name} --conservative

#{github_compare_url}
### Risks
[Medium] Gem bump.
  PR
end

def update_repos
  Dir.chdir "#{base_dir}"

  @repos.each do |repo|
    puts "Attempting to bump #{@gem_name} in #{repo}"
    Dir.chdir repo do
      sh "git checkout -b #{ENV['USER']}/bump-#{@gem_name}-6"

      @old_version = gem_version
      sh "bundle update #{@gem_name} --conservative"

      puts "New version is #{gem_version}"

      if old_version == gem_version
        puts "No update required"
      else
        sh "git add ."
        sh "git commit -m '#{commit_message}'"
        sh "hub pull-request -pm \"#{pr_message}\" --browse"
      end
    end
  end
end

begin
  if sh "hub --version"
    update_repos
  end
rescue
  puts "Error bumping your gem"
end

#!/usr/bin/ruby

def local_branches
  `git branch --list`.gsub(/[ |\*]/,'').split("\n")
end

def remote_branches
  `git branch --remote`.gsub('origin/','').gsub(/ -\>.*/,'').split("\n")
end

def all_branches
  # =>
    # hash_finder
  # * index_finder
    # master
    # remotes/origin/HEAD -> origin/master
    # remotes/origin/index_finder
    # remotes/origin/master
end

def branch_exists_locally?(branch)
  local_branches.any? { |local| local == branch }
end

def branch_exists_remotely?(branch)
  remote_branches.any? { |remote| remote == branch }
end

def validate_inputs
  if ARGV.count == 0
    puts "Please enter a branch name!"
    exit
  elsif ARGV.count > 1
    puts "Name can't have spaces!"
    exit
  end

  if ARGV.first == 'HEAD'
    puts "Branch name can't be HEAD"
    exit
  end

  if ARGV.first == 'master'
    puts "I'm not pushing to master"
    exit
  end
end

def validate_origin_exists
  if `git remote` == ''
    puts "no origin configured"
    exit
  end
end

def validate_branches(branch)
  if branch_exists_locally? branch
    puts "Local branch #{branch} exists!"
    exit
  elsif branch_exists_remotely? branch
    puts "Remote branch #{branch} exists!"
    exit
  end
end

def create_local_branch(branch)
  puts "creating local branch"
  `git checkout -b #{branch}`
end

def stage_all_files
  puts "staging"
  `git add -u . `
end

def commit_wip
  puts "committing"
  `git commit -m "WIP"`
end

def push_wip(branch)
  # assumes remote is at origin
  puts "pushing to remote"
  `git push origin #{branch}`
end


validate_inputs
branch = ARGV.first
validate_origin_exists
validate_branches(branch)

create_local_branch(branch)
stage_all_files
commit_wip
push_wip(branch)

### a change

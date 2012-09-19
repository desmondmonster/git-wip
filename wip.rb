#!/usr/bin/ruby

class Wip

  def self.process(argv)
    validate_input(argv)
    validate_origin_exists

    wip = new(argv.first)
    wip.validate_branches
    wip.create_branch_and_push
  end

  def initialize(wip_branch)
    @wip_branch = wip_branch
  end

  def local_branches
    `git branch --list`.gsub(/[ |\*]/,'').split("\n")
  end

  def remote_branches
    `git branch --remote`.gsub('origin/','').gsub(/ -\>.*/,'').split("\n")
  end

  def branch_exists_locally?
    local_branches.any? { |local| local == @wip_branch }
  end

  def branch_exists_remotely?
    remote_branches.any? { |remote| remote == @wip_branch }
  end


  def validate_branches
    if branch_exists_locally?
      puts "Local branch #{@wip_branch} exists!"
      exit
    elsif branch_exists_remotely?
      puts "Remote branch #{@wip_branch} exists!"
      exit
    end
  end

  def create_branch_and_push
    `git checkout -b #{@wip_branch}`
    `git add -u . `
    `git commit -m "WIP"`
    `git push origin #{@wip_branch}` # assumes remote is at origin
  end

  def self.validate_origin_exists
    # connection error, etc
    if `git remote` == ''
      puts "no origin configured"
      exit
    end
  end

  def self.validate_input(argv)
    if argv.count == 0
      puts "Please enter a branch name!"
      exit
    elsif argv.count > 1
      puts "Name can't have spaces!"
      exit
    end

    if argv.first == 'HEAD'
      puts "Branch name can't be HEAD"
      exit
    end

    if argv.first == 'master'
      puts "I'm not pushing to master"
      exit
    end
  end
end

Wip.process(ARGV)

#!/usr/bin/ruby
#

def branches
  `git branch -l`.split("\n")
end

puts branches



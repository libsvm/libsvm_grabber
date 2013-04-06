#!/usr/bin/env ruby

require 'time'

data_dir = File.expand_path('../libsvm_grabber_data', File.dirname(__FILE__))
repo_dir = File.expand_path('../libsvm_orig', File.dirname(__FILE__))

dirs = Dir["#{data_dir}/*"].select {|f| File.directory?(f)}
dirs.sort!

def execute?
  true
end

def run_command cmd
  puts "executing: #{cmd}"
  system(cmd) if execute?
end

def explore_subdir dir
  Dir["#{dir}/*"].first
end

# create and config repository
run_command "rm -rf #{repo_dir}"
run_command "mkdir #{repo_dir}"
run_command "cd #{repo_dir} && git init"
run_command "cd #{repo_dir} && git config core.autocrlf input"

# add libsvm versions
dirs.each do |dir|
  libsvm = dir.gsub("#{data_dir}/", '')

  file = dir + '.zip'
  f = File.open(file)
  time = f.mtime.utc.iso8601

  puts "time: #{time}"
  puts "processing: #{dir}: #{libsvm}"

  subdir = explore_subdir(dir)
  run_command "cd #{repo_dir} && rm -r *"
  run_command "cp -r #{subdir}/* #{repo_dir}/"

  ENV['GIT_AUTHOR_DATE'] = time
  ENV['GIT_COMMITTER_DATE'] = time
  run_command "cd #{repo_dir} && git add -A && git commit -m '#{libsvm}'"
end

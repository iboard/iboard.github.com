# -*- encoding : utf-8 -*-
#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'haml'
require 'erb'
require File.expand_path('../lib/helpers', __FILE__)

task :default => 'build'

task :build do
  puts "Building http://iboard.github.com ...."
  build_index
end

def build_index
  puts "# WRITE INDEX ..."
  clear_html_files
  write_index
  Dir.glob("pages/*haml.erb") do |file|
    printf "# MAKE FILE #{file}"
    make_file(file)
    puts ""
  end
  `open index.html`
end

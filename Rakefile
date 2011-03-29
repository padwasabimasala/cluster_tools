require File.expand_path(File.join(File.dirname(__FILE__), '../../config/env')) if !defined? HIVE_ROOT
require 'cluster_tools'

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each do |f|
  load f
end

namespace :cluster_tools do
  desc 'stub task'
  task :stub do
    puts :cluster_tools
  end
end

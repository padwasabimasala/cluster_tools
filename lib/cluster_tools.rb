require File.expand_path(File.join(File.dirname(__FILE__), '../../../config/env')) if !defined? HIVE_ROOT

module ClusterTools
  class ClusterToolsError < StandardError; end

  autoload :Base, 'cluster_tools/base'
  autoload :TaskMaster, 'cluster_tools/task_master'
  autoload :Worker, 'cluster_tools/worker'
  autoload :WorkerPool, 'cluster_tools/worker_pool'
  autoload :WorkerRegistry, 'cluster_tools/worker_registry'
end

# Shortcut ;)
CT = ClusterTools

require File.expand_path(File.join(File.dirname(__FILE__), '../../../config/env')) if !defined? HIVE_ROOT

module ClusterTools
  class Base
    def some_method # Delete at your leisure
      'cluster_tools'
    end
  end
end

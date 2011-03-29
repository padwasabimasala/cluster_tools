require File.dirname(__FILE__) + '/setup'
require 'cluster_tools'

class TestClusterTools < Test::Unit::TestCase
  def test_some_method
    assert_equal('cluster_tools', ClusterTools::Base.new.some_method)
  end
end

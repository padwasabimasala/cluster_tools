require 'setup'
require 'eventmachine' 
require 'msgpack'
require 'cluster_tools'
require 'test_worker'

class TestTaskMaster < Test::Unit::TestCase
  def test_do_task
    CT::WorkerPool.class_eval do
      attr_reader :workers
      attr_reader :tasks
    end

    host, port = '0.0.0.0', 9000

    EM::run do
      EM::start_server host, port, Adder
      wp = CT::WorkerPool.new
      wp.add("#{host}:#{port}", [:add])
      tm = CT::TaskMaster.new(wp)
      tm.do_task(:add, [2,10])
      EM.add_timer(0.01) {assert_equal(Adder.result, 12)}
      EM.add_timer(0.02) {EM.stop}
    end
  end
end

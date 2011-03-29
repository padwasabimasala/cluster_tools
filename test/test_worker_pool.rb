require 'setup'
require 'cluster_tools'

class TestWorkerPool < Test::Unit::TestCase
  CT::WorkerPool.class_eval do
    attr_reader :tasks
    attr_reader :workers
  end

  def test_add_and_pop
    wp = CT::WorkerPool.new
    host1 = ['bruce', [:fight, :dance]] # name, tasks
    host2 = ['chuck', [:fight]]
    host3 = ['julia', [:cook]]

    wp.add(host1.first, host1.last)
    wp.add(host2.first, host2.last)
    wp.add(host3.first, host3.last)

    assert_equal(wp.tasks.keys.map{|k| k.to_s}.sort, ['cook', 'dance', 'fight'])
    assert_equal(wp.tasks[:fight], [host1.first, host2.first])
    assert_equal(wp.workers.keys.sort, ['bruce', 'chuck', 'julia'])

    w = wp.pop(:fight)
    assert_equal(w, 'chuck')
    w = wp.pop(:dance)
    assert_equal(w, 'bruce')
    w = wp.pop(:fight)
    assert_equal(w, nil)

  end

  def test_expiration
    wp = CT::WorkerPool.new(0.1)
    host1 = ['bruce', [:fight, :dance]] # name, tasks
    host2 = ['chuck', [:fight]]

    wp.add(host1.first, host1.last)
    wp.add(host2.first, host2.last)

    w = wp.pop(:fight)
    assert_equal(w, 'chuck')

    sleep 0.1
    w = wp.pop(:dance)
    assert_equal(w, nil)
  end

end

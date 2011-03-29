require 'setup'
require 'cluster_tools'
require 'socket'
require 'msgpack'
require 'eventmachine' 

class TestWorkerRegistry < Test::Unit::TestCase
  def test_register
    host, port = '0.0.0.0', 9000

    add_worker = proc do
      sock = TCPSocket.open(host, port)
      sock.write({:host => 'bruce', :tasks => [:fight, :dance]}.to_msgpack)
    end

    EM::run do
       CT::WorkerPool.class_eval do 
        attr_reader :workers
      end
      wp = CT::WorkerPool.new
      EM::start_server host, port, CT::WorkerRegistry, wp
      EM::defer(add_worker)
      EM.add_timer(0.01) {assert(wp.workers.keys.include? 'bruce')}
      EM.add_timer(0.02) {EM.stop}
    end
  end

end

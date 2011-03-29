require 'setup'
require 'cluster_tools'
require 'eventmachine'
require 'msgpack'

class Adder < CT::Worker
  @@result = 0

  def self.result
    @@result
  end

  def self.result=(val)
    @@result = val
  end

  def add(a, b)
    Adder.result = a + b
  end
end

class TestWorker < Test::Unit::TestCase
  def test_worker
    host, port = '0.0.0.0', 9000

    add_two_and_ten = proc do
      sock = TCPSocket.open(host, port)
      sock.write({:task => :add, :args => [2, 10]}.to_msgpack)
    end

    EM::run do
      EM::start_server host, port, Adder
      EM::defer(add_two_and_ten)
      EM.add_timer(0.01) {assert_equal(Adder.result, 12)}
      EM.add_timer(0.02) {EM.stop}
    end
  end

end

require 'socket'

class ClusterTools::TaskMaster
  def initialize(worker_pool)
    @wp = worker_pool
  end

  def do_task(task, args)
    worker = @wp.pop(task)
    # todo handle nil worker
    host, port = worker.split(':')
    sock = TCPSocket.open(host, port)
    sock.write({:task => task, :args => args}.to_msgpack)
    # todo check response
  end
 
end

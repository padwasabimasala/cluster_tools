require 'cluster_tools/worker_pool'
require 'eventmachine'
require 'msgpack'
# http://redmine.msgpack.org/projects/msgpack/wiki/Introduction

class ClusterTools::WorkerRegistry < EM::Connection
  def initialize(worker_pool, *args)
    super(*args)
    @wp = worker_pool
    @pac = MessagePack::Unpacker.new  # Stream Deserializer
  end

  def receive_data(data)
    @pac.feed(data)    
    @pac.each {|msg|  
      receive_object(msg)
    }
  end

  def receive_object(msg)
    @wp.add(msg["host"], msg["tasks"])
  end
end

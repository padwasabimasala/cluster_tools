require 'eventmachine'
require 'msgpack'

class ClusterTools::Worker < EM::Connection
  def initialize(*args)
    super
    @pac = MessagePack::Unpacker.new  # Stream Deserializer
  end

  def receive_data(data)    # on receiving data...
    @pac.feed(data)         # 1. append it to the buffer
    @pac.each {|msg|        # 2. take out objects
      receive_object(msg)   # 3. do anything
    }
  end

  def receive_object(msg)
    method, args = msg["task"], msg["args"]
    res = send(method.to_sym, *args)
    send_data res
    res
  end
end

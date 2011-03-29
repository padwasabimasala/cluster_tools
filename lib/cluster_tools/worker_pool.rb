class ClusterTools::WorkerPool
  def initialize(expiration=180)
    @expiration = expiration
    @tasks = {} # :task => [host1, host2 ...]
    @workers = {} # "host" => timestamp
  end

  def add(host, tasks)
    tasks.each do |act|
      add_or_update_task(host, act)
      @workers[host] = Time.new
    end
  end

  def pop(task)
    loop do
      wrk_ts = pull_worker(task)
      return if !wrk_ts
      return wrk_ts.first if !expired?(wrk_ts.last)
    end
  end

  private
  def add_or_update_task(host, act)
    wrk_q = @tasks[act]
    if wrk_q
      idx = wrk_q.index(host)
      wrk = wrk_q.delete_at(idx) if idx
      wrk_q << host
    else
      @tasks[act] = [host]
    end
  end

  def pull_worker(task)
    wrk_q = @tasks[task]
    return if !wrk_q 
    wrk = wrk_q.pop
    ts = @workers.delete(wrk)
    return [wrk, ts] if wrk && ts
  end

  def expired?(ts)
    ts + @expiration < Time.new
  end
 
end

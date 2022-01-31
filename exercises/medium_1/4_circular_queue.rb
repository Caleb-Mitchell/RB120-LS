class CircularQueue
  attr_accessor :array, :add_idx, :old_idx
  attr_reader :max_size

  def initialize(max_size)
    @array = Array.new(max_size)
    @add_idx = 0
    @old_idx = 0
    @max_size = max_size
  end

  def enqueue(obj)
    if array[add_idx] == nil
      array[add_idx] = obj
      add_idx == (max_size - 1) ? self.add_idx = 0 : self.add_idx += 1
    else
      array[add_idx] = obj
      add_idx == (max_size - 1) ? self.add_idx = 0 : self.add_idx += 1
      old_idx == (max_size - 1) ? self.old_idx = 0 : self.old_idx += 1
    end
  end

  def dequeue
    if array.all?(&:nil?)
      nil
    else
      oldest_obj = array[old_idx]
      array[old_idx] = nil
      old_idx == (max_size - 1) ? self.old_idx = 0 : self.old_idx += 1
      oldest_obj
    end
  end
end


queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

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
    current_value = array[add_idx]
    array[add_idx] = obj
    self.add_idx = increment(add_idx)
    self.old_idx = increment(old_idx) unless current_value.nil?
  end

  def dequeue
    return nil if array.all?(&:nil?)

    oldest_obj = array[old_idx]
    array[old_idx] = nil
    self.old_idx = increment(old_idx)
    oldest_obj
  end

  private

  def increment(position)
    position == (max_size - 1) ? 0 : position + 1
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

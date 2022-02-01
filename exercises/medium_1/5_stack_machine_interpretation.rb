class InvalidTokenError < StandardError; end
class EmptyStackError < StandardError; end
class MinilangError < StandardError; end

class Minilang
  COMMANDS = ['PUSH', 'ADD', 'SUB', 'MULT', 'DIV', 'MOD', 'POP', 'PRINT']

  attr_reader :stack

  def initialize(operations)
    @operations = operations
    @stack = []
    @register = 0
  end

  def n(value)
    @register = value.to_i
  end

  def push
    @stack << @register
  end

  def add
    @register += @stack.pop
  end

  def sub
    @register += @stack.pop
  end

  def mult
    @register *= @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = stack.pop
  end

  def print
    puts @register
  end

  def number?(command)
    command =~ /\A[-+]?\d+\z/
  end

  def validate_command(command)
    COMMANDS.include?(command)
  end

  def eval
    # split and push operations to array commands
    @commands = []
    @operations.split.each { |ele| @commands << ele }

    # Need to iterate through commands, and for each:
    # if not a number or what of the appropriate commands, raise an exemption
    # if a number, call method n(value)
    # if not a number, use send to call the appropriate method
    @commands.each do |command|
      if validate_command(command)
        send(command.downcase.intern)
      elsif number?(command)
        n(command.to_i)
      else
        raise InvalidTokenError, "Invalid token: #{command}"
      end
    end
  rescue MinilangError => error
    puts error.message
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

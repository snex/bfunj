class Stack < Array

  def pop
    return 0 if self.empty?
    super
  end

end

class BFunj
  MAX_STEPS = 10000
  COMMAND_MAP = { '>'  => :go_left,
                  '<'  => :go_right,
                  '^'  => :go_up,
                  'v'  => :go_down,
                  '?'  => :go_random,
                  '_'  => :horizontal_if,
                  '|'  => :vertical_if,
                  '+'  => :add,
                  '-'  => :subtract,
                  '*'  => :multiply,
                  '/'  => :divide,
                  '%'  => :modulo,
                  '!'  => :negate,
                  '`'  => :test_greater_than,
                  ':'  => :duplicate,
                  '\\' => :swap,
                  '$'  => :discard,
                  '#'  => :skip,
                  '&'  => :input,
                  '.'  => :output,
                  '@'  => :stop }.freeze

  attr_accessor :program
  attr_reader   :stack

  def initialize input_stream = $stdin, output_stream = $stdout
    @pc = { :row => 0, :col => 0 }
    @direction = :left
    @distance = 1
    @stack = Stack.new
    @input_stream = input_stream
    @output_stream = output_stream
  end

  def load_file filename
    @program = File.open(filename).readlines.map { |l| l.chomp }
    @height = @program.size
    @width = @program[0].size
  end

  def run max_steps = MAX_STEPS
    steps = 0
    @done = false
    loop do
      @distance = 1
      command = @program[@pc[:row]][@pc[:col]]
      process_command command
      advance_pc
      if MAX_STEPS != 0
        steps += 1
        break if steps > MAX_STEPS || @done
      end
    end
  end

  private

  def process_command command
    if COMMAND_MAP.include? command
      self.send COMMAND_MAP[command]
    elsif command =~ /\d/
      @stack.push command.to_s.to_i
    else
      #do nothing
    end
  end

  def go_left
    @direction = :left
  end

  def go_right
    @direction = :right
  end

  def go_up
    @direction = :up
  end

  def go_down
    @direction = :down
  end

  def go_random
    @direction = case rand(4)
                 when 0 then :left
                 when 1 then :right
                 when 2 then :up
                 when 3 then :down
                 end
  end

  def horizontal_if
    @direction = (@stack.pop == 0) ? :right : :left
  end

  def vertical_if
    @direction = (@stack.pop == 0) ? :down : :up
  end

  def add
    @stack.push( @stack.pop + @stack.pop )
  end

  def subtract
    first = @stack.pop
    second = @stack.pop
    @stack.push( second - first )
  end

  def multiply
    @stack.push( @stack.pop * @stack.pop )
  end

  def divide
    first = @stack.pop
    second = @stack.pop
    @stack.push( (first == 0) ? 0 : second / first )
  end

  def modulo
    first = @stack.pop
    second = @stack.pop
    @stack.push( (first == 0) ? 0 : second % first )
  end

  def negate
    @stack.push( @stack.pop == 0 ? 1 : 0 )
  end

  def test_greater_than
    @stack.push( (@stack.pop > @stack.pop) ? 1 : 0 )
  end

  def duplicate
    @stack.push( @stack.last )
  end

  def swap
    first = @stack.pop
    second = @stack.pop
    @stack.push( first )
    @stack.push( second )
  end

  def discard
    @stack.pop
  end

  def skip
    @distance = 2
  end

  def input
    @stack.push( @input_stream.getc.to_i )
  end

  def output
    @output_stream.puts( @stack.pop )
  end

  def stop
    @done = true
  end

  def advance_pc
    case @direction
      when :left
        @pc[:col] = (@pc[:col] + @distance) % @width
      when :right
        @pc[:col] = (@pc[:col] - @distance) % @width
      when :up
        @pc[:row] = (@pc[:row] - @distance) % @height
      when :down
        @pc[:row] = (@pc[:row] + @distance) % @height
    end
  end

end

class Stack < Array

  def pop
    return 0 if self.empty?
    super
  end

end

class BFunj
  MAX_STEPS = 10000

  attr_accessor :program
  attr_reader   :stack

  def initialize
    @pc = { :row => 0, :col => 0 }
    @direction = :left
    @distance = 1
    @stack = Stack.new
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
      steps += 1
      break if steps > MAX_STEPS || @done
    end
  end

  private

  def process_command command
    case command
    when '>'
      @direction = :left
    when '<'
      @direction = :right
    when '^'
      @direction = :up
    when 'v'
      @direction = :down
    when '?'
      @direction = case rand(4)
                   when 0 then :left
                   when 1 then :right
                   when 2 then :up
                   when 3 then :down
                   end
    when '_'
      @direction = (@stack.pop == 0) ? :right : :left
    when '|'
      @direction = (@stack.pop == 0) ? :down : :up
    when /\d/
      @stack.push command.to_s.to_i
    when '+'
      @stack.push( @stack.pop + @stack.pop )
    when '-'
      @stack.push( @stack.pop - @stack.pop )
    when '*'
      @stack.push( @stack.pop * @stack.pop )
    when '/'
      first = @stack.pop
      second = @stack.pop
      @stack.push( (second == 0) ? 0 : first / second )
    when '%'
      first = @stack.pop
      second = @stack.pop
      @stack.push( (second == 0) ? 0 : first % second )
    when '!'
      @stack.push( @stack.pop == 0 ? 1 : 0 )
    when '`'
      @stack.push( (@stack.pop > @stack.pop) ? 1 : 0 )
    when ':'
      @stack.push( @stack.last )
    when '\\'
      first = @stack.pop
      second = @stack.pop
      @stack.push( second )
      @stack.push( first )
    when '$'
      @stack.pop
    when '#'
      @distance = 2
    when '@'
      @done = true
    end
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

class Stack < Array

  def pop
    return 0 if self.empty?
    super
  end

end

class BFunj

  MAX_STEPS = 10000

  attr_accessor :data
  attr_reader   :pc, :width, :height, :direction, :stack

  def initialize
    @pc = { :row => 0, :col => 0 }
    @direction = :left
    @stack = Stack.new
  end

  def load_file filename
    @data = File.open(filename).readlines.map { |l| l.chomp }
    @height = @data.size
    @width = @data[0].size
  end

  def run max_steps = MAX_STEPS
    steps = 0
    loop do
      command = @data[@pc[:row]][@pc[:col]]
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
          @stack.push( @stack.pop / @stack.pop )
        when '%'
          @stack.push( @stack.pop % @stack.pop )
        when '!'
          @stack.push( @stack.pop == 0 ? 1 : 0 )
        when '`'
          @stack.push( (@stack.pop > @stack.pop) ? 1 : 0 )
        when '.'
          print @stack.pop.to_s
        when '@'
          break
      end
        advance_pc
      steps += 1
      break if steps > MAX_STEPS
    end
    @stack.inject { |sum, acc| sum += acc }
  end

  private

  def advance_pc
    case @direction
      when :left
        @pc[:col] = (@pc[:col] + 1) % @width
      when :right
        @pc[:col] = (@pc[:col] - 1) % @width
      when :up
        @pc[:row] = (@pc[:row] - 1) % @height
      when :down
        @pc[:row] = (@pc[:row] + 1) % @height
    end
  end

end

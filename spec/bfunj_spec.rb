require 'bfunj'

describe BFunj do
  before :all do
    @bfunj = BFunj.new
    @testfiles = Dir.glob("data/test/*.bfunj")
  end

  describe BFunj, "#load_file" do
    it "loads a bfunj file" do
      @bfunj.load_file @testfiles[0]
      program = File.open(@testfiles[0]).readlines.map { |l| l.chomp }
      @bfunj.program.should == program
    end
  end
  
  describe BFunj, "#run" do
    it "runs a bfunj program" do
      @testfiles.each do |test_file|
        bfunj = BFunj.new( IO.popen( 'echo 5' ), IO.new( IO.sysopen( '/dev/null', 'w' ), 'w' ) )
        expected_result = File.basename(test_file, '.bfunj').to_i
        bfunj.load_file test_file
        bfunj.run
        bfunj.stack.inject { |sum, acc| sum += acc }.should == expected_result
      end
    end
  end
end

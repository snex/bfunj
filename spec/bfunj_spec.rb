require 'bfunj'

describe BFunj do
  before :all do
    @bfunj = BFunj.new
    @testfiles = Dir.glob("data/test/*.bfunj")
  end

  describe BFunj, "#load_file" do
    it "loads a bfunj file" do
      @bfunj.load_file @testfiles[0]
      data = File.open(@testfiles[0]).readlines.map { |l| l.chomp }
      @bfunj.data.should == data
      @bfunj.height.should == data.size
      @bfunj.width.should == data[0].size
    end
  end
  
  describe BFunj, "#run" do
    it "runs a bfunj program" do
      @testfiles.each do |test_file|
        bfunj = BFunj.new
        expected_result = File.basename(test_file, '.bfunj').to_i
        bfunj.load_file test_file
        result = bfunj.run
        result.should == expected_result
      end
    end
  end
end

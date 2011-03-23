require 'bfunj'

describe Stack do
  describe Stack, "#pop" do
    it "returns 0 when the stack is empty" do
      stack = Stack.new
      stack.pop.should == 0
    end
  end
end

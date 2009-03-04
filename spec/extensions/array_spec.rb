require File.dirname(__FILE__) + '/../spec_helper'

describe Array do
  describe "to_hash" do
    it "should convert itself to a hash" do
      [[1,2],[3,4]].to_hash.should == {1 => 2, 3 => 4}
    end
    
    it "should allow sub arrays" do
      [[1,[2,3,4]], [[5], [6, [7,8]]]].to_hash.should == {1 => [2,3,4], [5] => [6, [7,8]]}
    end
  end
end

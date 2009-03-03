require File.dirname(__FILE__) + '/spec_helper'

describe Pattern do
  describe "pattern creation" do
    it "should load from yaml" do
      pattern = Pattern.new(:a_pattern, :summary => 'my summary', :category => 'dog')
      pattern.name.should == "A Pattern"
      pattern.summary.should == "my summary"
    end
  
    it "should have boolean methods for presence of attributes" do
      pattern = Pattern.new(:a_pattern, :summary => 'foo', :category => 'pony')
      pattern.name?.should be_true
      pattern.summary?.should be_true
      pattern.category?.should be_true
      pattern.story?.should be_false
      pattern.answer?.should be_false
      pattern.face?.should be_false    
    end
  end
end
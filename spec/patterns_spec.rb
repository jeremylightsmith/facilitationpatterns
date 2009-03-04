require File.dirname(__FILE__) + '/spec_helper'


describe Patterns do
  def fixtures(file)
    File.expand_path(File.join(File.dirname(__FILE__), "fixtures", file))
  end
  
  describe "fixture data" do
    it "should load patterns" do
      patterns = Patterns.new(fixtures("categories.yml"), fixtures("patterns")).reload
      patterns.size.should == 3

      fishbowl = patterns[:fishbowl]
      fishbowl.name.should == "Fishbowl"
      fishbowl.summary.should include("people sitting")
    end
  
    it "should load categories" do
      patterns = Patterns.new(fixtures("categories.yml"), fixtures("patterns")).reload
      patterns[:fishbowl].category == "Discussion"
      patterns[:ground_rules] == "Discussion"
      patterns[:ask_questions_with_answers] == "Approaching People"
    end
    
    it "should require all patterns in categories.yml to be found" do
      proc do
        Patterns.new(fixtures("categories_with_too_many_patterns.yml"), fixtures("patterns")).reload
      end.should raise_error(RuntimeError, 
        %{categories file is missing [] and shouldn't have ["losers_weepers", "finders_keepers"]})
    end
    
    it "should require all patterns to be in categories.yml" do
      proc do
        Patterns.new(fixtures("categories_with_not_enough_patterns.yml"), fixtures("patterns")).reload
      end.should raise_error(RuntimeError,
        %{categories file is missing ["fishbowl", "ground_rules"] and shouldn't have []})
    end
    
    it "should read an xml pattern" do
      patterns = Patterns.new(fixtures("categories.yml"), fixtures("patterns")).reload
      ground_rules = patterns[:ground_rules]
      ground_rules.summary.should == "ground rules are good"
      ground_rules.details.should == 
"Line 1 which is short
Line 2 which is very long and keeps going and going
           
Line 3 before which there is an extra line"
      ground_rules.credits.should == "Chris"
    end
  end

  describe "loading real data" do
    it "should load all" do
      patterns = Patterns.new.reload
      patterns.size.should > 10
      patterns[:fishbowl].name.should == "Fishbowl"    
    end
  end
end
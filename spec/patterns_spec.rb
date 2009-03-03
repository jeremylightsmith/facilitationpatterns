require File.dirname(__FILE__) + '/spec_helper'


describe Patterns do
  def fixtures(file)
    File.expand_path(File.join(File.dirname(__FILE__), "fixtures", file))
  end
  
  describe "fixture data" do
    it "should load patterns" do
      patterns = Patterns.load(fixtures("categories.yml"), fixtures("patterns"))
      patterns.size.should == 3

      fishbowl = patterns[:fishbowl]
      fishbowl.name.should == "Fishbowl"
      fishbowl.summary.should include("people sitting")
    end
  
    it "should load categories" do
      patterns = Patterns.load(fixtures("categories.yml"), fixtures("patterns"))
      patterns[:fishbowl].category == "Discussion"
      patterns[:ground_rules] == "Discussion"
      patterns[:ask_questions_with_answers] == "Approaching People"
    end
    
    it "should require all patterns in categories.yml to be found" do
      proc do
        Patterns.load(fixtures("categories_with_too_many_patterns.yml"), fixtures("patterns"))
      end.should raise_error(RuntimeError, 
        %{categories file is missing [] and shouldn't have ["losers_weepers", "finders_keepers"]})
    end
    
    it "should require all patterns to be in categories.yml" do
      proc do
        Patterns.load(fixtures("categories_with_not_enough_patterns.yml"), fixtures("patterns"))
      end.should raise_error(RuntimeError,
        %{categories file is missing ["fishbowl", "ground_rules"] and shouldn't have []})
    end
    
    it "should validate patterns against schema (no category)"
    it "should ammend patterns files with missing fields"
  end

  describe "loading real data" do
    it "should load all" do
      patterns = Patterns.load
      patterns.size.should > 10
      patterns[:fishbowl].name.should == "Fishbowl"    
    end
  end
end
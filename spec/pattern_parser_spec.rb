require File.dirname(__FILE__) + '/spec_helper'

describe PatternParser do
  attr_reader :parser
  
  before do
    @parser = PatternParser.new
  end
  
  describe "to_hash" do
    it "should convert doc to hash" do
      hash = parser.to_hash(new_doc("<dog>Bruno</dog><cat>Tom</cat><mouse></mouse>"))
      hash["dog"].should == "Bruno"
      hash["cat"].should == "Tom"
      hash["mouse"].should == nil
    end
    
    it "should trim whitespace but not remove it from inside stuff" do
      hash = parser.to_hash(new_doc("<my>  \n\n Very important\n\n\t  Whitespace    \t \n </my>"))
      hash["my"].should == "Very important\n\n\t  Whitespace"
    end
  end
  
  describe "validate!" do
    it "should return true if all tags are present" do
      valid("<apple/><banana/>\n <cat/>", "apple banana cat")
    end
    
    it "should return false if missing tags" do
      invalid("<apple/><cat/>", "apple banana cat")
    end

    it "should return false if tags out of order" do
      invalid("<apple/><cat/><banana/>", "apple banana cat")
    end
    
    it "should support optional tags" do
      valid("<apple/><banana/>", "apple? banana")
      valid("<banana/>", "apple? banana")
    end
    
    it "should support 0 or more tags" do
      valid("<banana/>", "apple* banana")
      valid("<apple/><cat/><banana/>", "apple* banana")
      valid("<apple/><apple/><banana/>", "apple* banana")
    end
    
    it "should support 1 or more tags" do
      invalid("<banana/>", "apple+ banana")
      valid("<apple/><banana/>", "apple+ banana")
      valid("<apple/><apple/><banana/>", "apple+ banana")
    end
    
    it "should parse real dtd" do
      valid "<name/><summary/><example/><details/><variation/><variation/><dont_forget/><problem/><answer/><credits/><todo/><story/>"
      valid "<summary/><example/><details/><variation/><dont_forget/><problem/><answer/><credits/><todo/><story/>"
      invalid "<summary/><example/><ddetails/><dont_forget/><problem/><answer/><credits/><todo/><story/>"
      invalid "<summary/><details/><example/><dont_forget/><problem/><answer/><credits/><todo/><story/>"
    end

    def valid(xml, dtd = PatternParser::DTD)
      parser.validate!(new_doc(xml), dtd)
    end
    
    def invalid(xml, dtd = PatternParser::DTD)
      proc { valid(xml, dtd) }.should raise_error(ValidationError)
    end
  end
  
  describe "fix" do
    it "should be okay with optional parameters" do
      fix("cat? dog", "<cat>Tom</cat><dog>Bob</dog>").should == "<cat>Tom</cat>\n<dog>Bob</dog>"
      fix("cat? dog", "<dog>Bob</dog>").should == "<dog>Bob</dog>"
    end
    
    it "should put entire skeleton in if it is missing" do
      fix("cat dog mouse", "").should == 
        "<cat></cat>\n<dog></dog>\n<mouse></mouse>"
    end

    it "should reorder tags" do
      fix("cat dog mouse", "<cat>Lion</cat><mouse>Jerry</mouse><dog>Ralf</dog>").should ==
        "<cat>Lion</cat>\n<dog>Ralf</dog>\n<mouse>Jerry</mouse>"
    end
    
    it "should leave empty tags expanded if reordering" do
      fix("cat dog mouse", "<cat>Lion</cat><mouse></mouse><dog>Ralf</dog>").should ==
        "<cat>Lion</cat>\n<dog>Ralf</dog>\n<mouse></mouse>"
    end
    
    it "should just delete weird keys if they're empty" do
      fix("cat dog", "<cat>Tom</cat><lion></lion><dog>Pluto</dog>").should ==
        "<cat>Tom</cat>\n<dog>Pluto</dog>"
    end
    
    it "should keep weird keys if they're not empty" do
      fix("cat dog", "<cat>Tom</cat><lion></lion><tiger>Stripe</tiger><bear>Da Bears</bear><dog>Pluto</dog>").should ==
        "<cat>Tom</cat>\n<dog>Pluto</dog>\n<tiger>Stripe</tiger>\n<bear>Da Bears</bear>"
    end

    def fix(dtd, xml)
      parser.fix(new_doc(xml), dtd)
    end
  end
  
  describe "parse_file" do
    include FileSandbox
    
    it "should parse a file" do
      sandbox["pattern.xml"].content = "<summary>The message</summary><details>The Joke</details>"
      
      hash = parser.parse_file("pattern.xml")
      
      hash["summary"].should == "The message"
      hash["details"].should == "The Joke"
      
      sandbox["pattern.xml"].content.should == 
"<summary>The message</summary>
<example></example>
<details>The Joke</details>
<variation></variation>
<dont_forget></dont_forget>
<problem></problem>
<answer></answer>
<credits></credits>
<todo></todo>
<story></story>"
    end
  end
  
  def new_doc(text)
    REXML::Document.new("<pattern>#{text}</pattern>")
  end

  def content
    sandbox["pattern.xml"].content
  end
  
  def set_content(value)
    sandbox["pattern.xml"].content = value
  end
end

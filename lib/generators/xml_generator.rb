
module Generators
  class XmlGenerator
    def process(context, content)
      XmlSimple.xml_in content
    end
  end
end
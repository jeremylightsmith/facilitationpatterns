require 'rexml/document'
require 'builder'

class ValidationError < RuntimeError
end

class PatternParser
  DTD = "name? summary example details variation+ dont_forget problem answer credits todo story"

  def parse_file(file)
    begin
      doc = REXML::Document.new("<pattern>#{File.read(file)}</pattern>")
      validate!(doc)
    rescue ValidationError
      File.open(file, "w") {|f| f << fix(doc)}

      doc = REXML::Document.new("<pattern>#{File.read(file)}</pattern>")
      validate!(doc)
    end
    
    return to_hash(doc)
  end

  def to_hash(doc)
    hash = {}
    doc.root.elements.each do |element|
      text = element.text
      text = text.strip if text.respond_to?(:strip)
      text = nil if text.blank?
      hash[element.name] = text
    end
    hash
  end
  
  def fix(doc, dtd = DTD)
    root = doc.root
    xml = []

    expected_tags = dtd.split.map {|tag| tag =~ /(\w+)(\?|\*|\+)?/; [$1, $2]}
    expected_tags.each do |tag_name, occurrence|
      if tag = root.elements[tag_name]
        if tag.text.blank?
          xml << "<#{tag_name}></#{tag_name}>"
        else
          xml << tag.to_s
        end
        root.delete(tag)
      else # it's not in the document already
        case occurrence
        when "+", nil
          xml << "<#{tag_name}></#{tag_name}>"
        when "?", "*"
          # do nothing, it's not required
        end
      end
    end

    root.elements.each do |element|
      xml << element.to_s unless element.text.blank?
    end

    xml.join("\n")
  end
  
  def parse_xml(contents)
    hash = XmlSimple.xml_in("<pattern>#{contents}</pattern>", 'ForceArray' => false)
    hash.each do |name, value|
      hash[name] = value.strip if value.respond_to?(:strip)
    end
    hash
  end
  
  def validate!(doc, dtd = DTD)
    names = doc.root.find_all {|e| e.class == REXML::Element}.
                     map {|e| e.name}.
                     join(" ")

    pattern = dtd.gsub(/(\w+)\?( ?)/, '(\1\2)?').
                  gsub(/(\w+)\+( ?)/, '(\1\2)+').
                  gsub(/(\w+)\*( ?)/, '(\1\2)*')

    if names =~ /#{pattern}/
      true
    else
      raise ValidationError, "expected #{names.inspect} to match #{pattern.inspect}"
    end
  end
end
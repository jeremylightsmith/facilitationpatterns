class Patterns
  ROOT_DIR = File.expand_path(File.dirname(__FILE__) + "/..")
  attr_reader :by_category
  
  def initialize(categories_file = ROOT_DIR + "/config/categories.yml", 
                 patterns_dir = ROOT_DIR + "/web")
    @categories_file = categories_file
    @patterns_dir = patterns_dir
    
    clear
  end
    
  def [](index)
    if index.is_a?(String) || index.is_a?(Symbol)
      @by_symbol[index.to_sym]
    else
      @patterns[index]
    end
  end
  
  def <<(pattern)
    @patterns << pattern
    (@by_category[pattern.category] ||= []) << pattern
    @by_symbol[pattern.symbol] = pattern
  end
  
  def size
    @patterns.size
  end
  
  def clear
    @patterns = []
    @by_category = {}
    @by_symbol = {}
    @parser = PatternParser.new
  end    
  
  def reload
    clear
    
    category_names_by_pattern_name = read_category_names_by_pattern_name
    pattern_files_by_pattern_name = lookup_pattern_files_by_pattern_name
    
    missing = pattern_files_by_pattern_name.keys - category_names_by_pattern_name.keys
    extra = category_names_by_pattern_name.keys - pattern_files_by_pattern_name.keys
    unless missing.empty? && extra.empty?
      raise "categories file is missing #{missing.inspect} and shouldn't have #{extra.inspect}" 
    end

    pattern_files_by_pattern_name.each do |name, file|
      category = category_names_by_pattern_name[name]
      pattern = Pattern.new(name.to_sym, load_file(file).merge(:category => category))
      self << pattern
    end

    self
  end
  
  private
  
  def read_category_names_by_pattern_name
    hash = {}
    load_file(@categories_file).each do |category_hash|
      category_hash.each do |category, pattern_names|
        pattern_names.each do |pattern_name|
          pattern_name = pattern_name.gsub(" ", "_").downcase
          hash[pattern_name] = category
        end
      end
    end
    hash
  rescue 
    puts "Error parsing #{load_file(@categories_file).inspect}" rescue
    raise
  end
  
  def lookup_pattern_files_by_pattern_name
    Dir[@patterns_dir + '/**/*.pattern.{yml,xml}'].map do |file|
      name = File.basename(file.sub(/.pattern.(yml|xml)$/, ''))
      [name, file]
    end.to_hash
  end
    
  def load_file(file)
    if file.ends_with?(".yml")
      YAML::load_file(file)
    elsif file.ends_with?(".xml")
      @parser.parse_file(file)
    else
      raise "unknown pattern format"
    end
  rescue 
    raise("error reading #{File.basename(file)}: #{$!.message} \n#{$!.backtrace}")
  end
end

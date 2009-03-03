class Patterns < Array
  ROOT_DIR = File.expand_path(File.dirname(__FILE__) + "/..")
  
  def [](index)
    if index.is_a?(String) || index.is_a?(Symbol)
      find {|pattern| pattern.symbol == index.to_sym }
    else
      super
    end
  end
      
  def self.load(categories_file = ROOT_DIR + "/config/categories.yml", 
                patterns_dir = ROOT_DIR + "/web")
    category_names_by_pattern_name = {}
    load_file(categories_file).each do |category, patterns|
      patterns.each do |pattern|
        name = pattern.gsub(" ", "_").downcase
        category_names_by_pattern_name[name] = category
      end
    end
    
    pattern_files_by_pattern_name = {}
    Dir[patterns_dir + '/**/*.pattern.yml'].each do |file|
      name = File.basename(file.sub(/.pattern.yml$/, ''))
      pattern_files_by_pattern_name[name] = file
    end
    
    missing = pattern_files_by_pattern_name.keys - category_names_by_pattern_name.keys
    extra = category_names_by_pattern_name.keys - pattern_files_by_pattern_name.keys
    unless missing.empty? && extra.empty?
      raise "categories file is missing #{missing.inspect} and shouldn't have #{extra.inspect}" 
    end
    
    patterns = Patterns.new
    pattern_files_by_pattern_name.each do |name, file|
      patterns << Pattern.new(name.to_sym, 
                              load_file(file).merge(:category => category_names_by_pattern_name[name]))
    end
    patterns
  end
  
  private
  
  def self.load_file(file)
    YAML::load_file(file) rescue raise("error reading #{File.basename(file)}: #{$!.message}")
  end
end

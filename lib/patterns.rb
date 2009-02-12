class Patterns < Array
  def [](index)
    if index.is_a?(String) || index.is_a?(Symbol)
      find {|pattern| pattern.symbol == index.to_sym }
    else
      super
    end
  end
      
  def self.load(dir)
    patterns = Patterns.new
    Dir[dir + '/**/*.pattern.yml'].each do |file|
      yml = YAML::load_file(file) rescue raise("error reading #{File.basename(file)}: #{$!.message}")
      name = File.basename(file.sub(/.pattern.yml$/, ''))
      patterns << Pattern.new(name.to_sym, yml)
    end
    patterns
  end
end

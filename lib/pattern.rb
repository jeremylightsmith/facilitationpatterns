class Pattern
  def initialize(symbol, options)
    @options = (options || {}).map {|key, value| [key.to_sym, value]}.to_hash
    @options[:symbol] ||= symbol
    @options[:name] ||= symbol.to_s.titleize
  end
    
  def method_missing(sym, *args)
    if sym.to_s.ends_with?("?")
      !self.send(sym.to_s[0..-2]).blank?
    elsif @options.has_key?(sym)
      @options[sym]
    else
      ''
    end
  end
end

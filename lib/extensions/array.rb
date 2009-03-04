class Array
  def to_hash
    hash = {}
    self.each do |key, value|
      hash[key] = value
    end
    hash
  end
end
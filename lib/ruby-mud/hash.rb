class Hash
  def get_multikey(key)
    value = self
    key.split('.').each do |k|
      unless value.nil?
        value = value[k]
      end
    end
    value
  end
end
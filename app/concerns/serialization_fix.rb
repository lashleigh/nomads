module SerializationFix
  def serializable_hash(options = nil)
    options ||= {}
    options = serialize_defaults.merge(options)
    obj = super(options)
    Array.wrap(options[:include]).each do |opt|
      obj[opt] = self.send(opt).serializable_hash
    end
    obj
  end
end

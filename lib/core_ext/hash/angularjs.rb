class Hash
  # {a:1, b:2}.to_ng_init # a=1;b=2
  def to_ng_init
    self.inject([]) do |result,(key,value)|
      value = if value.is_a?(Array)
                "[#{value.map(&:to_json).join(',')}]"
              else
                value.to_json
              end
      result << "#{key}=#{value}"
    end.join(';')
  end
end

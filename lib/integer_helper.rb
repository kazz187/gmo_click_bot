class Integer
  def to_jpy
    self.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end
end
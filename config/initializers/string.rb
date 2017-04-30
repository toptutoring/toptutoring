class String
  def extract_value(digits = 2)
    ((self.to_f).round(digits) * 100).to_i
  end
end

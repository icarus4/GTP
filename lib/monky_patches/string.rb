class String

  TRUE_VALUES = ['true'.freeze, '1'.freeze, 'yes'.freeze, 'on'.freeze, 't'.freeze]

  def is_number?
    true if Float(self) rescue false
  end

  def is_not_number?
    !is_number?
  end

  def is_integer?
    true if Integer(self) rescue false
  end

  def is_not_integer?
    !is_integer?
  end

  def to_bool
    TRUE_VALUES.include? self
  end
end

module ScopedAccessors

  def protected_attr_reader(*symbols)
    attr_reader *symbols
    protected *symbols
  end

  def protected_attr_writer(*symbols)
    attr_writer *symbols
    protected(symbols.map { |sym| "#{sym}=".to_sym })
  end

  def protected_attr_accesor(*symbols)
    self.protected_attr_reader *symbols
    self.protected_attr_writer *symbols
  end

  def private_attr_reader(*symbols)
    attr_reader *symbols
    private *symbols
  end

  def private_attr_writers(*symbols)
    attr_writer *symbols
    private(symbols.map { |sym| "#{sym}=".to_sym })
  end

  def private_attr_accesor(*symbols)
    self.private_attr_reader *symbols
    self.private_attr_writers *symbols
  end

end
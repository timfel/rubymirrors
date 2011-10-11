class MethodSpecFixture
  def source_location
    [__FILE__, __LINE__, __method__, self.class]
  end

  def removeable_method
  end

  def method_p_public; end
  def method_p_private; end
  private :method_p_private
  def method_p_protected; end
  protected :method_p_protected
end

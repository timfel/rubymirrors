class MethodSpecFixture
  def source_location
    [__FILE__, __LINE__, __method__, self.class]
  end
end

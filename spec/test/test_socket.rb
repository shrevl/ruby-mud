class TestSocket
  @closed = false
  
  def closed?
    @closed
  end
  
  def close
    @closed = true
  end
end
module User

  attr_accessor :login_id, :password, :id
  
  def set_id(id)
    @id = id
  end
  
  # copied from ActiveRecord
  def persisted?
    !(self.id.nil?)
  end
  
  # copied from ActiveRecord
  def new_record?
    !persisted?
  end
  
end

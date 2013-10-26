class Group < ActiveRecord::Base
  has_many :characters, inverse_of: :group
  
  def to_s
    name
  end
  
end

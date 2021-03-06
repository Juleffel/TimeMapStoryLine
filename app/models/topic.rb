class Topic < ActiveRecord::Base
  has_one :character, inverse_of: :topic
  has_one :node, inverse_of: :topic
  
  after_save -> { node.touch if node }
  before_destroy -> { node.touch if node }
end

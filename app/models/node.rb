class Node < ActiveRecord::Base
  belongs_to :topic, inverse_of: :node
  has_many :presences, inverse_of: :node
  has_many :characters, through: :presences
  
  default_scope -> {order(:begin_at)}
  
  def json_attributes
    attributes.merge({character_ids: character_ids})
  end
  
  def self.hash_by(key)
    hash = {}
    self.all.each do |obj|
      hash[obj.send(key)] = obj.json_attributes
    end
    hash
  end
end

class Character < ActiveRecord::Base
  belongs_to :user, inverse_of: :characters
  belongs_to :topic, inverse_of: :character
  belongs_to :group
  
  has_many :to_links, foreign_key: :from_character_id, inverse_of: :from_character, class_name: "Link"
  has_many :to_links_characters, through: :to_links, class_name: "Character", source: :to_character
  has_many :from_links, foreign_key: :to_character_id, inverse_of: :to_character, class_name: "Link"
  has_many :from_links_characters, through: :from_links, class_name: "Character", source: :from_character
  
  has_many :presences, inverse_of: :character
  has_many :nodes, through: :presences
  
  default_scope -> {order(:id)}
  
  def to_s
    (first_name || '') + ' ' + (last_name || '')
  end
  
  def nodes_updated_at
    nodes.maximum(:updated_at)
  end
  
  def json_attributes
    attributes.merge({node_ids: nodes.order(:begin_at).map(&:id), nodes_updated_at: nodes_updated_at, to_link_ids: to_link_ids, name: to_s})
  end
  
  def self.hash_by(key)
    hash = {}
    self.all.each do |obj|
      hash[obj.send(key)] = obj.json_attributes
    end
    hash
  end
end

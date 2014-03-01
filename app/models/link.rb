class Link < ActiveRecord::Base
  belongs_to :from_character, class_name: "Character", inverse_of: :to_links
  belongs_to :to_character, class_name: "Character", inverse_of: :from_links
  
  def json_attributes
    attributes.merge(
      node_from_id: from_character_id, 
      node_to_id: to_character_id,
      strengh: force.abs,
      label: title)
  end
  
  def self.hash_by(key)
    hash = {}
    self.all.each do |obj|
      hash[obj.send(key)] = obj.json_attributes
    end
    hash
  end
end

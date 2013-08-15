class Link < ActiveRecord::Base
  belongs_to :from_character, class_name: "Character", inverse_of: :to_links
  belongs_to :to_character, class_name: "Character", inverse_of: :from_links
  
  def json_attributes
    attributes
  end
  
  def self.hash_by(key)
    hash = {}
    self.all.each do |obj|
      hash[obj.send(key)] = obj.json_attributes
    end
    hash
  end
end

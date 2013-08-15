class Presence < ActiveRecord::Base
  belongs_to :node, inverse_of: :presences
  belongs_to :character, inverse_of: :presences
end

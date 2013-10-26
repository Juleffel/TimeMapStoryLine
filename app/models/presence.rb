class Presence < ActiveRecord::Base
  belongs_to :node, inverse_of: :presences, touch: true
  belongs_to :character, inverse_of: :presences, touch: true
end

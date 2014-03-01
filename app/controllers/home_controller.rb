class HomeController < ApplicationController
  def index
  end
  
  def graph
    
    @characters_by_id = Character.hash_by(:id)
    @links_by_id = Link.hash_by(:id)
    @groups_by_id = Group.hash_by(:id)
    @type_links_by_id = {
      1 => {
        "id" => 1,
        "name" => "All",
        "link_ids" => Link.all.map(&:id),
        "color" => "#AAA",
      }
    }
    
    @without_container = true
  end
end

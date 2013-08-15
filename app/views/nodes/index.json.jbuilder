json.array!(@nodes) do |node|
  json.extract! node, :longitude, :latitude, :title, :resume, :topic_id, :character_ids
  json.url node_url(node, format: :json)
end

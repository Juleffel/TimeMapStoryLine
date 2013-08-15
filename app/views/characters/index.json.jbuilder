json.array!(@characters) do |character|
  json.extract! character, :user_id, :first_name, :last_name, :birth_date, :birth_place, :sex, :avatar_url, :avatar_name, :copyright, :topic_id, :story, :resume, :small_rp, :anecdote
  json.url character_url(character, format: :json)
end

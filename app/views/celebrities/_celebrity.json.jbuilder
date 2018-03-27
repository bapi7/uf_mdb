json.extract! celebrity, :id, :celebrity_name, :birth_year, :death_year, :profession, :known_for, :created_at, :updated_at
json.url celebrity_url(celebrity, format: :json)

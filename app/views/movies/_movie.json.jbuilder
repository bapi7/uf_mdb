json.extract! movie, :id, :primary_title, :original_title, :start_year, :run_time_minutes, :genres, :created_at, :updated_at
json.url movie_url(movie, format: :json)

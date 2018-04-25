json.extract! user, :id, :user_name, :email_id, :date_of_birth, :user_type, :is_registered, :is_admin, :created_at, :updated_at
json.url user_url(user, format: :json)

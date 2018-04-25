json.extract! web_user, :id, :user_name, :email_id, :date_of_birth, :user_type, :is_regestered, :is_admin, :created_at, :updated_at
json.url web_user_url(web_user, format: :json)

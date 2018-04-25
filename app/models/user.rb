class User < ApplicationRecord
  before_save { self.email_id = email_id.downcase }
  validates :user_name, presence: true
  has_secure_password
end

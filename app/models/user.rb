class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, on: :create, length: {minimum: 6}
  validates :full_name, presence: true
end
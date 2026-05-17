class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

class Profile < ApplicationRecord
  validates :age, presence: true
  validates :ethnicity, presence: true
  validates :height, presence: true
  validates :body_type, presence: true
  validates :url, presence: true
  validates :picture, presence: true
  validates :name, presence: true
  validates :interests, presence: true
end

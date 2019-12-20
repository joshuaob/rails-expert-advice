class Question < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates :title, :description, presence: true
  belongs_to :user
  has_many :posts, dependent: :destroy

  def views
    (100..100_00).to_a.sample
  end
end

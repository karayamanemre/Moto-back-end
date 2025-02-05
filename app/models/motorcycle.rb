class Motorcycle < ApplicationRecord
  has_many :users, through: :reservations
  has_many :reservations, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 3 }
  validates :model_year, presence: true
  validates :engine, presence: true
  validates :fuel_type, presence: true

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    else
      nil
    end
  end
end

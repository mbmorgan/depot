class Product < ApplicationRecord
  validates :title, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)}i,
    message: "File must be a GIF, JPG, or PNG image."
  }
  validate :file_exists
  
  private
  def file_exists
    fname = Dir.pwd + File::Separator + "app" + File::Separator + "assets" + File::Separator + "images" + File::Separator + image_url.to_s
    unless File.exist?(fname)
      errors.add(:image_url, "#{fname} does not exist.")
    end
  end
end
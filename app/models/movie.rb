class Movie < ActiveRecord::Base

  has_many :reviews

  validates :title, presence: true

  validates :director, presence: true

  validates :runtime_in_minutes, numericality: { only_integer: true }

  validates :description, presence: true

  validates :release_date, presence: true

  validate :release_date_is_in_the_future

  mount_uploader :image, ImageUploader

  scope :search_by_title, -> (query){where("title like ?", "%#{query}%")}
  scope :search_by_director, ->(query) {where("director like ?", "%#{query}%")}
  scope :less_than_90, -> {where("runtime_in_minutes < 90")}
  scope :between_90_and_120_minutes, -> { where("runtime_in_minutes between 90 and 120") }
  scope :greater_than_120_minutes, -> { where("runtime_in_minutes > 120") }



  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size if reviews.size > 0
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end

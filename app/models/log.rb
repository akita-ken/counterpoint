class Log < ActiveRecord::Base
  validates :date, presence: true
  validates :description, presence: true
  validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

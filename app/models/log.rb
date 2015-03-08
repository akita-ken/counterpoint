class Log < ActiveRecord::Base
        validates :date, presence: true
        validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
end

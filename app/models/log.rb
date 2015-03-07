class Log < ActiveRecord::Base
        validates :date, presence: true
	validates :description, presence: true
        validates :duration, presence: true, numericality: { greater_than: 0 }
end

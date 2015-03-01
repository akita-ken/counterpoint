class LineItem < ActiveRecord::Base
	validates :item_name, presence: true
	validates :item_price, presence: true, numericality: true
end

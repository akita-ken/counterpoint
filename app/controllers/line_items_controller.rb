class LineItemsController < ApplicationController
	def index
		@line_items = LineItem.all
	end

	def new
		@line_item = LineItem.new
	end

	def edit
		@line_item = LineItem.find(params[:id])
	end

	def destroy
		@line_item = LineItem.find(params[:id])
		@line_item.destroy

		redirect_to line_item_path
	end

	def create
		@line_item = LineItem.new(line_item_params)

		if @line_item.save
			redirect_to @line_item
		else
			render 'new'
		end
	end

	def update
		@line_item = LineItem.find(params[:id])

		if @line_item.update(line_item_params)
			redirect_to @line_item
		else
			render 'edit'
		end		
	end

	def show
		@line_item = LineItem.find(params[:id])
	end

	private
		def line_item_params
			params.require(:line_item).permit(:item_name, :item_price)
		end
end

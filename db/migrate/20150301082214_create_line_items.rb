class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :item_name
      t.decimal :item_price

      t.timestamps null: false
    end
  end
end

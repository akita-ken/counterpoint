class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :date
      t.text :description
      t.float :duration

      t.timestamps null: false
    end
  end
end

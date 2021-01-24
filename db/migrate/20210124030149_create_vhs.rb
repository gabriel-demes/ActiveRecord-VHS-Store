class CreateVhs < ActiveRecord::Migration[5.2]
  def change
    create_table :vhs do |t|
      t.integer :movie_id
      t.string :serial_number
    end
  end
end

class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.string :description
      t.date :target_date
      t.float :target_value
      t.float :starting_value
      t.string :interval

      t.timestamps
    end
  end
end

class CreateStats < ActiveRecord::Migration[6.1]
  def change
    create_table :stats do |t|
      t.float :value
      t.date :date
      t.belongs_to :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class AddUnitOfMeasureToGoals < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :unit_of_measure, :string
  end
end

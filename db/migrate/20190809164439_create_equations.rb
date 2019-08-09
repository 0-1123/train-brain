class CreateEquations < ActiveRecord::Migration[5.2]
  def change
    create_table :equations do |t|
      t.string :solution
      t.integer :score

      t.timestamps
    end
  end
end

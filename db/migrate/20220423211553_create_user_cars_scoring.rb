class CreateUserCarsScoring < ActiveRecord::Migration[6.1]
  def change
    create_table :user_cars_scorings do |t|
      t.bigint :user_id, null: false
      t.bigint :car_id, null: false
      t.decimal :scoring, precision: 4, scale: 3, null: false
      t.timestamps

      t.index %i[car_id user_id], unique: true
    end
  end
end

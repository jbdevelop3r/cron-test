class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.string :name
      t.string :interval

      t.timestamps
    end
  end
end

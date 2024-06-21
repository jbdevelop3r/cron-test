class AddColumsToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :start_time, :string
    add_column :schedules, :end_time, :string
    add_column :schedules, :hour, :string
    add_column :schedules, :minutes, :string
  end
end

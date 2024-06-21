class AddActiveToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :active, :boolean
  end
end

class ChangeIntervalDataTypeInSchedules < ActiveRecord::Migration[7.1]
  def up
    change_column :schedules, :interval, 'integer USING CAST(interval AS integer)'
  end

  def down
    change_column :schedules, :interval, :string
  end
end

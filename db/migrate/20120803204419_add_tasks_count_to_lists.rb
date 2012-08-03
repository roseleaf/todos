class AddTasksCountToLists < ActiveRecord::Migration
  def change
    add_column :lists, :tasks_count, :integer, default: 0
  end
end

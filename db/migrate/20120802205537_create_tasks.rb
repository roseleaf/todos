class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :list_id
      t.text :text
      t.boolean :is_completed

      t.timestamps
    end
  end
end

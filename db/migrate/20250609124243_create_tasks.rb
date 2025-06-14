class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.boolean :completed
      t.references :daily_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end

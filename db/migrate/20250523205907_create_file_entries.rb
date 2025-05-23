class CreateFileEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :file_entries do |t|
      t.string :name
      t.references :directory, null: false, foreign_key: true

      t.timestamps
    end
  end
end

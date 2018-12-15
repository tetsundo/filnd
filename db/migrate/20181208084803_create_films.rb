class CreateFilms < ActiveRecord::Migration[5.2]
  def change
    create_table :films do |t|

      t.timestamps
      t.integer :genre_ids
      t.string :title
      t.integer :year
    end
  end
end

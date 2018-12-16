class CreateFilms < ActiveRecord::Migration[5.2]
  def change
    create_table :films do |t|

      t.timestamps
      t.string :title
      t.integer :year
      t.integer :genre
    end
  end
end

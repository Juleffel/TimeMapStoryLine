class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.belongs_to :user, index: true
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :birth_place
      t.boolean :sex
      t.string :avatar_url
      t.string :avatar_name
      t.string :copyright
      t.belongs_to :topic, index: true
      t.text :story
      t.text :resume
      t.text :small_rp
      t.text :anecdote

      t.timestamps
    end
  end
end

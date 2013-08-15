class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.float :longitude
      t.float :latitude
      t.text :title
      t.text :resume
      t.datetime :begin_at
      t.datetime :end_at
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end

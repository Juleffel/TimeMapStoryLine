class AddColorToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :color, :string
  end
end

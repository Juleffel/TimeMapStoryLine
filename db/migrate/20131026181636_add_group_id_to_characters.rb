class AddGroupIdToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :group_id, :integer
  end
end

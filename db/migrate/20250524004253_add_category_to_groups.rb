class AddCategoryToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :category, :string
  end
end

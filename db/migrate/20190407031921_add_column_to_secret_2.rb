class AddColumnToSecret2 < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :certificate, :string
    add_column :secrets, :key_handle, :string
    add_column :secrets, :public_key, :string
    add_column :secrets, :counter, :integer
  end
end

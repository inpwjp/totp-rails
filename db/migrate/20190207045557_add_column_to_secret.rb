# frozen_string_literal: true

class AddColumnToSecret < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :auth_type, :integer, defalut: 0
  end
end

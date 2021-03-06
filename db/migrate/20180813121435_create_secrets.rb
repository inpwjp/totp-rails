# frozen_string_literal: true

class CreateSecrets < ActiveRecord::Migration[5.2]
  def change
    create_table :secrets do |t|
      t.references :user
      t.string :secret_key

      t.timestamps
    end
  end
end

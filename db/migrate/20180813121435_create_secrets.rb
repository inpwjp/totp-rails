class CreateSecrets < ActiveRecord::Migration[5.2]
  def change
    create_table :secrets do |t|
      t.references :user
      t.string :secrete_key

      t.timestamps
    end
  end
end

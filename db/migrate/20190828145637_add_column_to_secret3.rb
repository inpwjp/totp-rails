class AddColumnToSecret3 < ActiveRecord::Migration[5.2]
  def change
    add_column :secrets, :mobile_number, :string
    add_column :secrets, :mobile_number_status, :string
    add_column :secrets, :sms_otp, :string
    add_column :secrets, :created_sms_otp_at, :timestamp
  end
end

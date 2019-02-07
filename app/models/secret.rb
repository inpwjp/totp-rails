# == Schema Information
#
# Table name: secrets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  secret_key :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Secret < ApplicationRecord
  belongs_to :user

  def authorize(otp)
    totp.verify(otp)
  end

  def totp_now
    totp.now
  end

  def totp 
    ROTP::TOTP.new(self.secret_key)
  end
end

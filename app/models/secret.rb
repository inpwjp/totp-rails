# frozen_string_literal: true
# == Schema Information
#
# Table name: secrets
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  secret_key  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  auth_type   :integer
#  certificate :string
#  key_handle  :string
#  public_key  :string
#  counter     :integer
#

class Secret < ApplicationRecord
  belongs_to :user

  enum auth_type: Settings.common.auth_type

  def authorize(otp)
    case auth_type
    when :totp then
      get_totp.verify(otp)
    else
      logger.warn(auth_type)
    end
  end

  def totp_now
    get_totp.now
  end

  def get_totp
    ROTP::TOTP.new(secret_key)
  end
end

# frozen_string_literal: true
# == Schema Information
#
# Table name: secrets
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  secret_key           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  auth_type            :integer
#  certificate          :string
#  key_handle           :string
#  public_key           :string
#  counter              :integer
#  mobile_number        :string
#  mobile_number_status :boolean          default(FALSE), not null
#  sms_otp              :string
#  created_sms_otp_at   :datetime
#

class Secret < ApplicationRecord
  belongs_to :user

  enum auth_type: Settings.common.auth_type

  def set_sms_otp(sms)
    self.auth_type = :sms
    self.sms_otp = sms.send_otp
    self.mobile_number = sms.e164
    self.created_sms_otp_at = Time.now
    self
  end

  def authorize(otp)
    case self.auth_type
    when "totp" then
      get_totp.verify(otp)
    when "sms" then
      return false if self.sms_otp.blank?
      if otp == self.sms_otp && 
            Time.now < (
              self.created_sms_otp_at +
              Settings.common.sms.expiration_minutes.minutes
            )
        return true
      end
      return false
    else
      logger.warn(auth_type)
      return false
    end
  end

  def totp_now
    get_totp.now
  end

  def get_totp
    ROTP::TOTP.new(secret_key)
  end
end

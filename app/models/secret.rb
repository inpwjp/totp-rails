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

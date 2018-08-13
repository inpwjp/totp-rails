class Secret < ApplicationRecord
  belongs_to :user

  def authorize(otp)
    totp.verify(otp)
  end

  def set_secret
    self.secret = ROTP::Base32.random_base32
  end

  def otp
    totp.now
  end

  def totp 
    ROTP::TOTP.new(self.secret)
  end
end

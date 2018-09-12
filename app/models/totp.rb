class Totp
  include ActiveModel::Model 
  attr_accessor :otp, :userid, :secret_key
end

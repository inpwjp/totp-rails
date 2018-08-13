class TotpController < ApplicationController
  def edit
    secret = ROTP::Base32.random_base32
    user = User.find(params[:id])
    @qr = RQRCode::QRCode.new(ROTP::TOTP.new(secret).provisioning_uri([user.user_id, "@", Settings.common.url].join), size: 8, level: :h).as_svg(module_size: 3).html_safe
    @now = ROTP::TOTP.new(secret).now
    @otp = Totp.new
  end

  def create
  end

  def destroy
  end
end


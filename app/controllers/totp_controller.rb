class TotpController < ApplicationController
  def edit
    @totp = Totp.new
    @totp.secret_key = ROTP::Base32.random_base32
    @user = User.find(params[:id])
    @qr = RQRCode::QRCode.new(ROTP::TOTP.new(@totp.secret_key).provisioning_uri([@user.user_id, "@", Settings.common.service_name].join), size: 8, level: :h).as_svg(module_size: 3).html_safe
  end

  def create
    @totp = Totp.new(params.require(:totp).permit(:otp,:secret_key))
    user = User.find(params[:id])
    if user.secret.nil?
      user.secret = Secret.new
    end
    user.secret.secret_key = @totp.secret_key
    if user.secret.authorize(@totp.otp)
      user.secret.save
      redirect_to user_path(id: user.id)
    else
      flash[:warn] = "failure"
      @totp.otp = nil
      @user = User.find(params[:id])
      @qr = RQRCode::QRCode.new(ROTP::TOTP.new(@totp.secret_key).provisioning_uri([@user.user_id, "@", Settings.common.url].join), size: 8, level: :h).as_svg(module_size: 3).html_safe
      render :edit
    end
  end

  def check
    @user = User.find(params[:id])
    flash[:warn] = ""
    if params[:totp].present?
      @totp = Totp.new(params.require(:totp).permit(:otp))
      if @user.secret.try(:authorize, @totp.otp)
        flash[:warn] = "success"
      else
        flash[:warn] = "failure"
      end
    else
      @totp = Totp.new()
    end
    render :check
  end

  def destroy
    user = User.find(params[:id])
    user.secret.try(:delete)
    redirect_to user_path(id: user.id)
  end
end

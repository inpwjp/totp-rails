# frozen_string_literal: true

class TotpController < ApplicationController
  def edit
    @totp = Totp.new
    @totp.secret_key = ROTP::Base32.random_base32
    @user = User.find(params[:id])
    @qr = RQRCode::QRCode.new(ROTP::TOTP.new(@totp.secret_key).provisioning_uri([@user.user_id, '@', Settings.common.service_name].join), size: 8, level: :h).as_svg(module_size: 3).html_safe
  end

  def create
    @totp = Totp.new(params.require(:totp).permit(:otp, :secret_key))
    user = User.find(params[:id])
    secret = Secret.new
    secret.secret_key = @totp.secret_key
    secret.auth_type = :totp
    if secret.authorize(@totp.otp)
      user.secrets << secret
      user.save
      redirect_to user_path(id: user.id)
    else
      flash[:warn] = 'failure'
      @totp.otp = nil
      @user = User.find(params[:id])
      @qr = RQRCode::QRCode.new(ROTP::TOTP.new(@totp.secret_key).provisioning_uri([@user.user_id, '@', Settings.common.url].join), size: 8, level: :h).as_svg(module_size: 3).html_safe
      render :edit
    end
  end

  def check
    @user = User.find(params[:id])
    flash[:warn] = ''
    if params[:totp].present?
      @totp = Totp.new(params.require(:totp).permit(:otp))
      flash[:warn] = if @user.secrets.select { |secret| secret.try(:authorize, @totp.otp) if secret.totp? }.compact.present?
                       'success'
                     else
                       'failure'
                     end
    else
      @totp = Totp.new
    end
    render :check
  end

  def destroy
    user = User.find(params[:id])
    secret = Secret.find(params[:secret_id])
    secret.try(:delete)
    redirect_to user_path(id: user.id)
  end
end

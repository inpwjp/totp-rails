# frozen_string_literal: true

class FidoController < ApplicationController
  def new
    # Generate one for each version of U2F, currently only `U2F_V2`
    @registration_requests = u2f.registration_requests

    # Store challenges. We need them for the verification step
    session[:challenges] = @registration_requests.map(&:challenge)

    # Fetch existing Registrations from your db and generate SignRequests
    key_handles = Registration.map(&:key_handle)
    @sign_requests = u2f.authentication_requests(key_handles)

    @app_id = u2f.app_id

    render 'registrations/new'
  end

  def create
    @totp = Totp.new(params.require(:totp).permit(:otp, :secret_key))
    user = User.find(params[:id])
    if user.secret.nil?
      user.secret = Secret.new
    end
    user.secret.secret_key = @totp.secret_key
    if user.secret.authorize(@totp.otp)
      user.secret.save
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
      flash[:warn] = if @user.secret.try(:authorize, @totp.otp)
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
    user.secret.try(:delete)
    redirect_to user_path(id: user.id)
  end
end

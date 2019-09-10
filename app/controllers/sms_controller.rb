class SmsController < ApplicationController
  def edit
    @sms = Sms.new(to: params.try(:sms).try(:to))
    @sms.userid = params[:id]
  end

  def create
    @sms = Sms.new(params.require(:sms).permit(:userid, :sms_otp))
    @user = User.find(@sms.userid)
    secret = @user.secrets.where(auth_type: :sms).first
    logger.info secret.authorize(@sms.sms_otp)
    if secret.try(:authorize, @sms.sms_otp)
      secret.mobile_number_status = true
      secret.save
      flash[:warn] = 'success'
      redirect_to user_path(id: @sms.userid)
    else
      secret.delete
      flash[:warn] = 'failure'
      redirect_to edit_sms_path(id: @sms.userid)
    end
  end

  def confirm
    @sms = Sms.new(params.require(:sms).permit(:to, :sms_otp, :userid))
    @user = User.find(params[:id])
    @user.secrets.where(auth_type: :sms).delete_all

    secret = Secret.new
    @user.secrets << secret.set_sms_otp(@sms)
    logger.info @user.secrets.to_json
  end

  def check
    @user = User.find(params[:id])
    if params[:sms].present?
      @sms = Sms.new(params.require(:sms).permit(:sms_otp, :userid))
      if @user.secrets
        .where(auth_type: :sms)
        .first.try(:authorize, @sms.sms_otp)
        flash[:warn] = 'success'
      else
        flash[:warn] = 'failure'
      end
    end
    secret = @user.secrets.where(
      auth_type: :sms,
      mobile_number_status: true).first
    if secret.blank?
      flash[:warn] = 'error'
      @sms = Sms.new
      @user = User.find(params[:id])
    else
      @sms = Sms.new(to: secret.mobile_number)
      secret = @user.secrets.where(auth_type: :sms).first
      secret.sms_otp = @sms.send_otp
      secret.created_sms_otp_at = Time.now
      secret.save
    end
  end
end

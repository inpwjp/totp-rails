class SmsController < ApplicationController
  def edit
    @sms = Sms.new(userid: params[:id])
  end

  def create
    @sms = Sms.new(sms_params)
    @user = User.find(@sms.userid)
    if @user.secrets.select do |secret| 
          if(secret.sms? &&
              secret.created_sms_otp_at < Time.now &&
              Time.now < (
                secret.created_sms_otp_at +
                Settings.common.sms.expiration_minutes.minutes
              ) &&
              secret.try(:authorize, @sms.sms_otp)
            )
          end
        end.compact.present?
      flash[:warn] = 'success'
      redirect to: show_users_path(id: @sms.userid)
    else
      flash[:warn] = 'failure'
      redirect to: edit_sms_path(id: @sms.userid)
    end
  end

  def confirm
    @sms_form = SmsForm.new(sms_form_params)
  end

  def check
    @user = User.find(params[:id])
    if params[:sms].present?
      @sms = Sms.new(sms_params)
      flash[:warn] =
        if @user.secrets.select do |secret| 
              if(secret.sms? &&
                  secret.created_sms_otp_at < Time.now &&
                  Time.now < (
                    secret.created_sms_otp_at +
                    Settings.common.sms.expiration_minutes.minutes
                  ) &&
                  secret.try(:authorize, @sms.sms_otp)
                )
              end
            end.compact.present?
          'success'
        else
          'failure'
        end
    else
      @sms_form = sms.new
    end
  end
end

# frozen_string_literal: true

class FidoController < ApplicationController

  # 登録用メソッド
  def edit
    @user = User.find(params[:id])
    @registration_requests = u2f.registration_requests

    session[:challenges] = @registration_requests.map(&:challenge)
    session[:user_id] = @user.id
    key_handles = Secret.where(
      user: @user,
      auth_type: "fido_u2f"
    ).all.map{|secret| secret.key_handle}.compact

    @sign_requests = u2f.authentication_requests(key_handles)

    @app_id = u2f.app_id

    render 'fido/edit'
  end

  def create
    response = U2F::RegisterResponse.load_from_json(params[:response])
    user_id = session[:user_id]
    begin
      reg = u2f.register!(session[:challenges], response)
      Secret.create!(
        user_id: user_id,
        auth_type: "fido_u2f",
        certificate: reg.certificate,
        key_handle: reg.key_handle,
        public_key: reg.public_key,
        counter: reg.counter
      )
    rescue U2F::Error => e
      @error_message = "Unable to register: #{e.class.name}"
    ensure
      session.delete(:challenges)
      session.delete(:user_id)
    end
    redirect_to user_path(user_id)
  end

  def check
    @user = User.where(id: params[:id]).first

    @app_id = u2f.app_id
    key_handles = Secret.where(
      user: @user,
      auth_type: "fido_u2f"
    ).all.map{|secret| secret.key_handle}.compact

    @sign_requests = u2f.authentication_requests(key_handles)
    @challenge = u2f.challenge
    if params[:response].present?
      response = U2F::SignResponse.load_from_json(params[:response])

      begin
        registration = Secret.where(
          user: @user,
          key_handle: response.key_handle
        ).first 

        u2f.authenticate!(session[:u2f_challenge], response,
                          Base64.decode64(registration.public_key),
                          registration.counter)
        flash[:warn] = "success"
      rescue U2F::Error => e
        @error_message = "Unable to authenticate: #{e.class.name}"
        flash[:warn] = "failure"
      ensure
        session.delete(:u2f_challenge)
      end
      registration.update(counter: response.counter)
    end 
    session[:u2f_challenge] = @challenge
  end

  # ライブラリの初期化
  def u2f
    @u2f ||= U2F::U2F.new(request.base_url)
  end
end

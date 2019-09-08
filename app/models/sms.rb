class Sms
  include ActiveModel::Model

  attr_accessor :from, :to, :body, :sms_otp, :userid

  # メッセージを送るためのメソッド
  def send_message(to = self.to, from = self.from, body = self.body)
    return false if to.blank?

    from ||= Settings.common.twilio.from_number
    body ||= 'Hello world!'
    get_client.messages.create(
      from: from,
      to: to,
      body: body
    )
  end

  # 認証用のOTPを送るためのメソッド
  def send_otp(to = self.to, from = self.from)
    sms_otp = format(
      "%0#{Settings.common.sms.otp_length}d",
      SecureRandom.random_number(10**Settings.common.sms.otp_length)
    )
    body = "SMSテスト送信の認証番号は #{sms_otp}となります。"
    send_message(to, from, body)

    sms_otp
  end

  def convert_e164
    self.to = e164
  end

  def e164
    if /^0(\d+)([\s-]{0,1})(\d+)([\s-]{0,1}(\d+))/ =~ self.to
      PhonyRails.normalize_number(
        self.to,
        Settings.common.sms.location
      )
    else
      self.to
    end
  end

  def plausible?
    Phony.plausible?(e164)
  end

  private
  def set_client
    @client = Twilio::REST::Client.new(
      Settings.common.twilio.account_sid,
      Settings.common.twilio.auth_token
    )
  end
end

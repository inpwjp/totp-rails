class Sms
  attr_accessor :from, :to, :body

  # Twilioクライアントを初期化する
  def initialize
    @client = Twilio::REST::Client.new(
      Settings.common.twilio.account_sid,
      Settings.common.twilio.auth_token
    )
    self.from = Settings.common.twilio.from_number
    self.body = 'Hello world!'
  end

  # メッセージを送るためのメソッド
  def send_message(to = self.to, from = self.from, body = self.body)
    @client.messages.create(
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
end

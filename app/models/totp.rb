# frozen_string_literal: true

class Totp
  include ActiveModel::Model
  attr_accessor :otp, :userid, :secret_key
end

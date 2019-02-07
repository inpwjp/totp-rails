# frozen_string_literal: true

class Sessions
  include ActiveModel::Model
  attr_accessor :user_id, :otp
end

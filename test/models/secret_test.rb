# frozen_string_literal: true
# == Schema Information
#
# Table name: secrets
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  secret_key           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  auth_type            :integer
#  certificate          :string
#  key_handle           :string
#  public_key           :string
#  counter              :integer
#  mobile_number        :string
#  mobile_number_status :boolean          default(FALSE), not null
#  sms_otp              :string
#  created_sms_otp_at   :datetime
#

require 'test_helper'

class SecretTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

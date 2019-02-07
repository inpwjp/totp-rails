# frozen_string_literal: true

# == Schema Information
#
# Table name: secrets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  secret_key :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auth_type  :integer
#

require 'test_helper'

class SecretTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

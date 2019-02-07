# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_one :secret
end

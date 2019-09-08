# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :basic

  private
  def basic
    authenticate_or_request_with_http_basic do |name, password|
      name == ENV['BASIC_USER_ID'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end

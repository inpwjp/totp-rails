# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @sessions = Sessions.new
  end

  def create; end

  def destroy; end
end

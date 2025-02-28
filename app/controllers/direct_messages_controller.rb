# frozen_string_literal: true

class DirectMessagesController < ApplicationController
  before_action :require_login
  before_action :set_direct_message, only: [:show]

  def show
    mark_as_read
  end

  def set_direct_message
    @direct_message = current_user.received_direct_messages.active.find(params[:id])
  end

  private

  def mark_as_read
    current_user.direct_message_reads.find_or_create_by(direct_message: @direct_message)
  end
end

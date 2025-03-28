# frozen_string_literal: true

class DirectMessagesController < ApplicationController
  before_action :require_login
  before_action :set_direct_message, only: [:show]

  def index
    @direct_messages = current_user.received_direct_messages.roots.active.recent.page(params[:page])
  end

  def show
    mark_as_read

    if @direct_message.reply?
      redirect_to direct_message_path(@direct_message.parent)
      return
    end

    @replies = @direct_message.replies.includes(:admin).active.order(:created_at)

    @replies.each do |reply|
      current_user.direct_message_reads.find_or_create_by(direct_message: reply)
    end

    can_reply = false

    if @direct_message.replyable?
      last_reply = @replies.last

      if last_reply.nil?
        can_reply = true
      elsif last_reply.admin.admin? && last_reply.allow_reply?
        can_reply = true
      end
    end

    @reply = DirectMessage.new(parent_id: @direct_message.id) if can_reply
  end

  def create_reply
    @parent_message = current_user.received_direct_messages.active.find(params[:id])

    root_message = @parent_message.root? ? @parent_message : @parent_message.parent

    unless @parent_message.replyable?
      redirect_to direct_message_path(root_message), alert: 'このメッセージには返信できません'
      return
    end

    last_reply = root_message.replies.active.order(created_at: :desc).first

    if last_reply && (!last_reply.admin.admin? || !last_reply.allow_reply?)
      redirect_to direct_message_path(root_message), alert: 'このメッセージにはこれ以上返信できません'
      return
    end

    @reply = DirectMessage.new(reply_params)
    @reply.admin = current_user
    @reply.recipient = @parent_message.admin
    @reply.parent_id = root_message.id
    @reply.status = :published
    @reply.published_at = Time.current
    @reply.allow_reply = false

    if @reply.save
      DirectMessageRead.where(direct_message: root_message).where.not(user: current_user).delete_all

      redirect_to direct_message_path(root_message), success: '返信を送信しました'
    else
      @direct_message = root_message
      @replies = root_message.replies.active.order(:created_at)
      render :show
    end
  end

  private

  def set_direct_message
    @direct_message = current_user.received_direct_messages.active.find(params[:id])
  end

  def mark_as_read
    read = current_user.direct_message_reads.find_or_create_by(direct_message: @direct_message)
    read.touch if read.persisted?
  end

  def reply_params
    params.require(:direct_message).permit(:title, :content)
  end
end

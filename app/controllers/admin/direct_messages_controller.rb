# frozen_string_literal: true

module Admin
  class DirectMessagesController < Admin::BaseController
    def index
      @direct_messages = DirectMessage.recent.page(params[:page])
    end

    def new
      @direct_message = DirectMessage.new
      @users = User.where(role: :general).order(:name)
    end

    def edit
      @direct_message = DirectMessage.find(params[:id])
      @users = User.where(role: :general).order(:name)
    end

    def create
      @direct_message = DirectMessage.new(direct_message_params)
      @direct_message.admin = current_user

      if @direct_message.save
        redirect_to admin_direct_messages_path, success: t('.success')
      else
        @users = User.where(role: :general).order(:name)
        render :new
      end
    end

    def update
      @direct_message = DirectMessage.find(params[:id])
      if @direct_message.update(direct_message_params)
        redirect_to admin_direct_messages_path, success: t('.success')
      else
        @users = User.where(role: :general).order(:name)
        render :edit
      end
    end

    def publish
      @direct_message = DirectMessage.find(params[:id])
      if @direct_message.update(status: :published, published_at: Time.current)
        redirect_to admin_direct_messages_path, success: t('.success')
      else
        redirect_to admin_direct_messages_path, error: t('.failure')
      end
    end

    def archive
      @direct_message = DirectMessage.find(params[:id])
      if @direct_message.update(status: :archived)
        redirect_to admin_direct_messages_path, success: t('.success')
      else
        redirect_to admin_direct_messages_path, error: t('.failure')
      end
    end

    private

    def direct_message_params
      params.require(:direct_message).permit(:title, :content, :status, :priority, :recipient_id, :published_at)
    end
  end
end

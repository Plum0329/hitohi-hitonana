# frozen_string_literal: true

module Admin
  class DirectMessagesController < Admin::BaseController
    def index
      @direct_messages = DirectMessage.roots.recent.page(params[:page])
    end

    def show
      @direct_message = DirectMessage.find(params[:id])

      if @direct_message.reply?
        redirect_to admin_direct_message_path(@direct_message.parent)
        return
      end

      @replies = @direct_message.replies.includes(:admin, :recipient).order(:created_at)
    end

    def new
      @direct_message = DirectMessage.new
      @users = User.where(role: :general).order(:name)
    end

    def new_reply
      @parent_message = DirectMessage.find(params[:id])

      root_message = @parent_message.root? ? @parent_message : @parent_message.parent

      recipient_id = if @parent_message.admin_id == current_user.id
                       @parent_message.recipient_id
                     else
                       @parent_message.admin_id
                     end

      @direct_message = DirectMessage.new(
        parent_id: root_message.id,
        recipient_id: recipient_id,
        title: "Re: #{@parent_message.title}"
      )
      @users = User.where(role: :general).order(:name)

      @original_reply = @parent_message
    end

    def edit
      @direct_message = DirectMessage.find(params[:id])
      @users = User.where(role: :general).order(:name)
    end

    def create
      @direct_message = DirectMessage.new(direct_message_params)
      @direct_message.admin = current_user

      if @direct_message.save
        if @direct_message.parent_id.present?
          DirectMessageRead.where(direct_message: @direct_message.parent)
                           .where(user: @direct_message.recipient)
                           .delete_all
        end

        redirect_target = if @direct_message.parent_id.present?
                            @direct_message.parent
                          else
                            @direct_message
                          end

        redirect_to admin_direct_message_path(redirect_target), success: t('.success')
      else
        @users = User.where(role: :general).order(:name)
        render :new
      end
    end

    def update
      @direct_message = DirectMessage.find(params[:id])
      if @direct_message.update(direct_message_params)
        redirect_to admin_direct_message_path(@direct_message), success: t('.success')
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
      params.require(:direct_message).permit(:title, :content, :status, :priority, :recipient_id, :published_at,
                                             :allow_reply, :parent_id)
    end
  end
end

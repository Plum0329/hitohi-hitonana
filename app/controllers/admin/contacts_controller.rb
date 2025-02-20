# frozen_string_literal: true

module Admin
  class ContactsController < Admin::BaseController
    before_action :set_contact, only: %i[show update reply confirm_reply]

    def index
      @contacts = Contact.recent
                         .by_status(params[:status])
                         .by_category(params[:category])
                         .page(params[:page])
    end

    def show; end

    def update
      if @contact.update(contact_params)
        redirect_to admin_contact_path(@contact), notice: '更新しました'
      else
        render :show
      end
    end

    def confirm_reply
      @reply_content = params[:reply_content]
      return if @reply_content.present?

      redirect_to admin_contact_path(@contact), alert: '返信内容を入力してください'
      nil
    end

    def reply
      if @contact.reply(params[:reply_content])
        ContactMailer.reply_email(@contact).deliver_now
        redirect_to admin_contact_path(@contact), notice: '返信メールを送信しました'
      else
        redirect_to admin_contact_path(@contact), alert: '返信内容を入力してください'
      end
    end

    private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:status, :admin_memo, :reply_content)
    end
  end
end

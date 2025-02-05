class ContactsController < ApplicationController
  skip_before_action :require_login

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      render 'pages/contact'
    else
      render :confirm
    end
  end

  def create
    @contact = Contact.new(contact_params)
    if params[:back]
      render 'pages/contact'
      return
    end

    if @contact.save
      redirect_to thanks_contacts_path, notice: 'お問い合わせを受け付けました。'
    else
      render 'pages/contact'
    end
  end

  def thanks
  end

  private

  def contact_params
    params.require(:contact).permit(
      :name,
      :email,
      :content,
      :category,
      :privacy_policy_agreed
    )
  rescue ActionController::ParameterMissing
    flash.now[:alert] = '不正なパラメータです'
    {}
  end
end
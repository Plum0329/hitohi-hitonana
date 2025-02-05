class PagesController < ApplicationController
  skip_before_action :require_login

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
    if params[:contact]
      @contact = Contact.new(contact_params)
    else
      @contact = Contact.new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :category, :privacy_policy_agreed)
  end
end
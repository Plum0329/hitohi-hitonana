# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :require_login

  def about; end

  def terms; end

  def privacy; end

  def contact
    @contact = if params[:contact]
                 Contact.new(contact_params)
               else
                 Contact.new
               end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content, :category, :privacy_policy_agreed)
  end
end

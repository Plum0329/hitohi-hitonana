class Admin::ContactsController < Admin::BaseController
  before_action :set_contact, only: [:show, :update]

  def index
    @contacts = Contact.recent
                      .by_status(params[:status])
                      .by_category(params[:category])
                      .page(params[:page])
  end

  def show
  end

  def update
    if @contact.update(contact_params)
      redirect_to admin_contact_path(@contact), notice: '更新しました'
    else
      render :show
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:status, :admin_memo)
  end
end
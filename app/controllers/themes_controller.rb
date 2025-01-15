class ThemesController < ApplicationController
  before_action :require_login
  before_action :set_theme, only: [:show, :write]

  def index
    @themes = Theme.all.order(created_at: :desc)
  end

  def show
    @posts = @theme.posts.includes(:user, :tags).order(created_at: :desc)
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = current_user.themes.build(theme_params)
    if @theme.save
      redirect_to @theme, notice: 'お題を作成しました'
    else
      render :new
    end
  end

  def write
    return redirect_to login_path, alert: 'ログインが必要です' unless current_user
    session[:theme_id] = @theme.id
    redirect_to new_type_theme_posts_path(@theme)
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        @theme = Theme.find(params[:id])

        unless @theme.user == current_user
          redirect_to @theme, alert: '削除権限がありません'
          return
        end

        if @theme.destroy
          flash[:notice] = 'お題を削除しました'
          redirect_to themes_path
        else
          flash[:alert] = '削除できませんでした'
          redirect_to @theme
        end
      end
    rescue => e
      logger.error "Theme destroy error: #{e.message}"
      logger.error e.backtrace.join("\n")
      redirect_to @theme, alert: '削除中にエラーが発生しました'
    end
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end

  def theme_params
    params.require(:theme).permit(:description, :image)
  end
end
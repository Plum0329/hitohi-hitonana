class ThemesController < ApplicationController
  before_action :set_theme, only: [:show, :edit, :update, :destroy, :all_posts]
  skip_before_action :require_login, only: [:index, :show, :all_posts]

  def index
    base_themes = Theme.available
                      .includes(:user, :posts, :likes)
                      .order(created_at: :desc)

    @themes = if params[:user_id].present?
                base_themes.where(user_id: params[:user_id])
              else
                base_themes
              end

    @themes = @themes.page(params[:page]).per(10)
  end

  def show
    ensure_theme_visible
    @show_like_button = true
    @first_post = @theme.posts.first
    @my_post = @theme.posts.find_by(user: current_user) if logged_in?
    @random_posts = @theme.posts.where.not(id: [@first_post&.id, @my_post&.id].compact)
                          .order("RANDOM()").limit(3)
    @total_posts_count = @theme.posts.count
  end

  def all_posts
    ensure_theme_visible
    @show_like_button = false
    @posts = @theme.posts.includes(:user, :tags)
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(10)
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = current_user.themes.build(theme_params)
    if @theme.save
      redirect_to themes_path, notice: 'お題を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @theme.update(theme_params)
      redirect_to theme_path(@theme), notice: 'お題を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        @theme.posts.update_all(image_post_id: nil)
        @theme.destroy!
      end
      redirect_to themes_path, notice: 'お題を削除しました'
    rescue => e
      logger.error "Theme destroy error: #{e.message}"
      redirect_to themes_path, alert: '削除中にエラーが発生しました'
    end
  end

  def all_posts
    @posts = @theme.posts.includes(:user, :tags).order(created_at: :asc).page(params[:page])
    @show_like_button = false
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end

  def theme_params
    params.require(:theme).permit(:title, :description, :image)
  end

  def ensure_theme_visible
    unless @theme.deleted_at.nil? || (current_user && current_user.admin?)
      redirect_to themes_path, alert: 'お題が見つかりませんでした'
    end
  end
end
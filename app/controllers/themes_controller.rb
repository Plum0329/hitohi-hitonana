class ThemesController < ApplicationController
  before_action :set_theme, only: [:show, :edit, :update, :destroy, :all_posts]
  skip_before_action :require_login, only: [:index, :show, :all_posts]

  def index
    @themes = Theme.includes(:user, :image_post).order(created_at: :desc).page(params[:page])
  end

  def show
    @first_post = @theme.posts.order(:created_at).first
    @my_post = @theme.posts.find_by(user: current_user) if logged_in?
    @random_posts = @theme.posts.where.not(id: [@first_post&.id, @my_post&.id].compact).order("RANDOM()").limit(3)
    @total_posts_count = @theme.posts.count
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
    @theme.destroy
    redirect_to themes_path, notice: 'お題を削除しました'
  end

  def all_posts
    @posts = @theme.posts.includes(:user, :tags).order(created_at: :desc).page(params[:page])
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(:title, :description, :image)
  end
end
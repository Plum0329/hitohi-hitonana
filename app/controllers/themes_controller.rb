# frozen_string_literal: true

class ThemesController < ApplicationController
  include Sortable

  before_action :set_theme, only: %i[show edit update destroy all_posts]
  skip_before_action :require_login, only: %i[index show all_posts]

  def index
    @themes = Theme.available
                   .includes(:user, :posts, :likes)

    @themes = @themes.where(user_id: params[:user_id]) if params[:user_id].present?

    @themes = sort_records(@themes).page(params[:page]).per(20)
  end

  def show
    ensure_theme_visible
    @show_like_button = true
    @first_post = @theme.posts.first
    @my_post = @theme.posts.find_by(user: current_user) if logged_in?
    @random_posts = @theme.posts.where.not(id: [@first_post&.id, @my_post&.id].compact)
                          .order('RANDOM()').limit(3)
    @total_posts_count = @theme.posts.count
  end

  def all_posts
    ensure_theme_visible
    @show_like_button = false
    @posts = @theme.posts.includes(:user, :tags)
    @posts = sort_records(@posts).page(params[:page]).per(20)
  end

  def new
    @theme = Theme.new
  end

  def edit; end

  def create
    @theme = current_user.themes.build(theme_params)
    if @theme.save
      redirect_to themes_path, notice: 'お題を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @theme.update(theme_params)
      redirect_to theme_path(@theme), notice: 'お題を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @theme.posts.update_all(image_post_id: nil)
      @theme.destroy!
    end
    redirect_to themes_path, notice: 'お題を削除しました'
  rescue StandardError => e
    logger.error "Theme destroy error: #{e.message}"
    redirect_to themes_path, alert: '削除中にエラーが発生しました'
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
    return if @theme.deleted_at.nil? || current_user&.admin?

    redirect_to themes_path, alert: 'お題が見つかりませんでした'
  end
end

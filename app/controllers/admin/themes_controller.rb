# frozen_string_literal: true

module Admin
  class ThemesController < Admin::BaseController
    before_action :set_theme, only: %i[show edit update destroy soft_delete restore]

    def index
      @themes = Theme.includes(:user, :posts, :likes)

      @themes = case params[:filter]
                when 'available'
                  @themes.available
                when 'deleted'
                  @themes.deleted
                else
                  @themes
                end

      @themes = sort_records(@themes).page(params[:page]).per(20)
    end

    def show
      @theme = Theme.includes(:user, :posts, :likes).find(params[:id])
      @recent_posts = @theme.posts.includes(:user, :likes)
                            .order(created_at: :desc)
                            .limit(5)
    end

    def new
      @theme = Theme.new
    end

    def edit; end

    def create
      @theme = Theme.new(theme_params)
      if @theme.save
        redirect_to admin_theme_path(@theme), notice: 'お題を作成しました'
      else
        render :new
      end
    end

    def update
      ActiveRecord::Base.transaction do
        @theme.image.purge if params[:remove_image] == '1'

        if @theme.update(theme_params)
          redirect_to admin_theme_path(@theme), notice: 'お題を更新しました'
        else
          render :edit, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      Rails.logger.error "更新エラー: #{e.message}"
      flash.now[:alert] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end

    def soft_delete
      if @theme.soft_delete
        redirect_to admin_theme_path(@theme), notice: 'お題を非表示にしました'
      else
        flash.now[:alert] = '非表示にできませんでした'
        render :show
      end
    end

    def restore
      if @theme.restore
        redirect_to admin_theme_path(@theme), notice: 'お題を再表示しました'
      else
        flash.now[:alert] = '再表示できませんでした'
        render :show
      end
    end

    def destroy
      @theme.destroy
      redirect_to admin_themes_path, notice: 'お題を削除しました'
    end

    private

    def set_theme
      @theme = Theme.find(params[:id])
    end

    def theme_params
      params.require(:theme).permit(:description, :status, :image)
    end
  end
end

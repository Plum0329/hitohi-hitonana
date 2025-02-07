class PostsReportsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:new, :confirm, :create]
  before_action :ensure_not_post_owner, only: [:new, :confirm, :create]

  def new
    @posts_report = if params[:posts_report].present?
      PostsReport.new(posts_report_params.merge(post: @post))
    else
      PostsReport.new(post: @post)
    end
  end

  def confirm
    @posts_report = current_user.posts_reports.build(posts_report_params)
    @posts_report.post = @post

    unless @posts_report.valid?
      return render :new
    end

    render :confirm
  end

  def create
    @posts_report = current_user.posts_reports.build(posts_report_params)
    @posts_report.post = @post

    if params[:back].present?
      render :new
      return
    end

    if @posts_report.save
      redirect_to posts_report_path(@posts_report), notice: '報告を受け付けました'
    else
      render :new
    end
  end

  def show
    @posts_report = current_user.posts_reports.find(params[:id])
  end

  private

  def posts_report_params
    params.require(:posts_report).permit(:reason_category, :reason)
  rescue ActionController::ParameterMissing
    {}
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def ensure_not_post_owner
    if @post.user == current_user
      redirect_to root_path, alert: '自分の投稿は報告できません'
    end
  end
end
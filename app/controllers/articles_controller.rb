class ArticlesController < ApplicationController

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params.merge(user_id: @current_user.id))

    if @article.save
      redirect_to article_path(@article)
    end
  end

  def index
    @articles = Article.order("id desc")
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(article_params)
      redirect_to article_path(@article)
    end
  end

  def destroy
    @article = Article.find(params[:id])

    if @article.destroy
      redirect_to root_path
    end
  end

  def ra_plugins
    render layout: false, template: "/articles/ra_plugins/#{params[:template]}"
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :hashtags)
    end

end

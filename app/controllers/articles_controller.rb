class ArticlesController < ApplicationController

  before_filter :login_required, only: [:create, :new, :edit, :update, :destroy]

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
    @article.increment!(:hits_count)
    
    if @article.photos.present?
      @og_image = "http://#{SiteHost}#{@article.photos.first.url(:thumb)}"
    end
  end

  def edit
    @article = Article.find(params[:id])

    unless @article.owned_by?(@current_user)
      flash[:notice] = "권한이 없습니다."
      redirect_to root_path
    end
  end

  def update
    @article = Article.find(params[:id])

    unless @article.owned_by?(@current_user)
      flash[:notice] = "권한이 없습니다."
      redirect_to root_path
    end

    if @article.update_attributes(article_params)
      redirect_to article_path(@article)
    end
  end

  def destroy
    @article = Article.find(params[:id])

    unless @article.owned_by?(@current_user)
      flash[:notice] = "권한이 없습니다."
      redirect_to root_path
    end

    if @article.destroy
      redirect_to root_path
    end
  end

  def ra_plugins
    render layout: false, template: "/articles/ra_plugins/#{params[:template]}"
  end

  def search
    search_keyword = params[:q].blank? ? "*" : "*#{params[:q]}*"
    queries = ["#{search_keyword}"]

    if params[:sort].blank?
      @articles = Article.search(query: {
        query_string: {
          fields: ["content"],
          query: queries.join(" AND "),
          use_dis_max: true
        }
      }, sort: { id: { order: "desc" }}).records
    else
      @articles = Article.search(query: {
        query_string: {
          fields: ["content"],
          query: queries.join(" AND "),
          use_dis_max: true
        }
      }, sort: { hits_count: { order: "desc" }}).records
    end
  end

  def autocomplete
    term = params[:term].to_s

    if term.present?
      @articles = Article.search(query: {
        query_string: {
          fields: ["title"],
          query: "#{term}*"
        }
      }).records

      matches = @articles.collect {|x| {value: x.title, id: x.id, link: article_path(x)}}
    end

    render json: matches
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :hashtags)
    end

end

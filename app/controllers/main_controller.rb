class MainController < ApplicationController

  def index
    @articles = Article.order("id desc")
  end

end

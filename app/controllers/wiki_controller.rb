class WikiController < ApplicationController
  def index
    @wiki_pages = WikiPage.all
  end
  
  def new
    @wiki_page = WikiPage.new
  end
  
  def create
    @wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    @wiki_page.save
  end
  
  def show
    @wiki_page = WikiPage.find(params[:id])
  end
  
end

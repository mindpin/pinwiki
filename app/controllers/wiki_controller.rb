class WikiController < ApplicationController
  def index

  end
  
  def new
    @wiki_page = WikiPage.new
  end
  
  def create
    @wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    @wiki_page.save
  end
  
  def show
    
  end
  
end

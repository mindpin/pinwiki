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
    
    redirect_to '/wiki'
  end
  
  def show
    @wiki_page = WikiPage.find(params[:id])
  end
  
  def edit
    @wiki_page = WikiPage.find(params[:id])
  end
  
  def update
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.update_attributes(params[:wiki_page])
    redirect_to '/wiki'
  end
  
  def destroy
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.destroy
    
    redirect_to '/wiki'
  end
  
  # 改动的版本列表
  def versions
    @versions = Audit.all
  end
  
end

class WikiController < ApplicationController

  
  def index
    @wiki_pages = WikiPage.all
  end
  
  def new
    @wiki_page = WikiPage.new
  end
  
  def create
    wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    wiki_page.save
    
    # 同时为该条目创建一个新的版本
    WikiPageVersion.create(
      :wiki_page_id => wiki_page.id,
      :version => wiki_page.audits.count, 
      :title => wiki_page.title, 
      :content => wiki_page.content
    )
    
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
    
    # 同时为该条目创建一个新的版本
    WikiPageVersion.create(
      :wiki_page_id => @wiki_page.id,
      :version => @wiki_page.audits.count,
      :title => @wiki_page.title, 
      :content => @wiki_page.content
    )
    redirect_to '/wiki'
  end
  
  def destroy
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.destroy
    
    redirect_to '/wiki'
  end
  
  # 所有的版本历史记录列表
  def history
    @history = Audit.all
  end
  
  # 改动的版本列表
  def versions
    @wiki_page = WikiPage.find(params[:id])
    @versions = @wiki_page.audits
  end
  
  # 单条记录的版本回滚
  def page_rollback
    audit = Audit.find_by_version(params[:id])
    wiki_page = WikiPage.find(audit.auditable_id)
    
    case audit.action
    when 'create', 'update'
      # page = audit.audited_changes.each_line.map {|l| l.split(':').last.strip}
      wiki_page.title = audit.wiki_page_version.title
      wiki_page.content = audit.wiki_page_version.content
      wiki_page.creator_id = audit.wiki_page_version.creator_id
      wiki_page.save
    end
    #p audit.audited_changes
    #p page
    #p 'ffffffffffffffffffffffffffffffff'
    
    redirect_to "/wiki/#{audit.auditable_id}"
  end
  
  
  # 所有记录的版本回滚
  def rollback
    audit = Audit.find_by_version(params[:id])
    wiki_page = WikiPage.find(audit.auditable_id)
    
    case audit.action
    when 'create', 'update'
      # page = audit.audited_changes.each_line.map {|l| l.split(':').last.strip}
      wiki_page.title = audit.wiki_page_version.title
      wiki_page.content = audit.wiki_page_version.content
      wiki_page.creator_id = audit.wiki_page_version.creator_id
      wiki_page.save
      
    when 'destroy'
      WikiPage.create(
        :wiki_page_id => audit.auditable_id,
        :title => audit.wiki_page_version.title,
        :content => audit.wiki_page_version.content,
        :creator_id => audit.wiki_page_version.creator_id
      )
    end
    
    redirect_to "/wiki"
  end
  
end

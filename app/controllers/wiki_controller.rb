class WikiController < ApplicationController

  def index
    @wiki_pages = WikiPage.all
  end
  
  def new
    @wiki_page = WikiPage.new
  end
  
  def create
    wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    # wiki_page = WikiPage.new(params[:wiki_page])
    wiki_page.save

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
=begin
    wiki_page = WikiPage.find(params[:auditable_id])
    audits = wiki_page.find_rollback(params[:audit_id])
    
    audits.each do |audit|
      # wiki_page.rollback(audit)
     _rollback_audit(audit)
    end
=end
    wiki_page = WikiPage.find(params[:auditable_id])
    audit = Audit.find(params[:audit_id])
    wiki_page.rollback(audit)
    
    redirect_to "/wiki"

  end
  
  
  # 所有记录的版本回滚
  def rollback
=begin
    audits = Audit.find_rollback_versions(params[:audit_id])
    audits.each do |audit|
      # WikiPage.system_rollback(audit)
      _rollback_audit(audit)
    end
=end
    audit = Audit.find(params[:audit_id])
    WikiPage.system_rollback(audit)
    
    redirect_to "/wiki"
  end
  

=begin
  def _rollback_audit(audit)
    case audit.action
      when 'create'
        wiki_page = WikiPage.find(audit.auditable_id)
        wiki_page.destroy unless wiki_page.nil?

      when 'update'
        # page = audit.audited_changes.each_line.map {|l| l.split(':').last.strip}

        wiki_page = WikiPage.find(audit.auditable_id)

        wiki_page.title = audit.wiki_page_version.prev.title
        wiki_page.content = audit.wiki_page_version.prev.content
        wiki_page.creator_id = audit.wiki_page_version.prev.creator_id
        wiki_page.save
     
      when 'destroy'
        wiki_page = WikiPage.new

        wiki_page.id = audit.wiki_page_version.wiki_page_id
        wiki_page.title = audit.wiki_page_version.title
        wiki_page.content = audit.wiki_page_version.content
        wiki_page.creator_id = audit.wiki_page_version.creator_id
        
        wiki_page.save

    end
  end

=end
  
end

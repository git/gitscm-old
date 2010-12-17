ActionController::Routing::Routes.draw do |map|
  map.root :controller => "page"

  map.with_options :controller => 'page' do |page|
    page.about 'about', :action => 'about'
    page.about 'documentation', :action => 'documentation'
    page.about 'download', :action => 'download'
    page.about 'tools', :action => 'tools'
    page.about 'sfc', :action => 'sfc'
    page.about 'appeal', :action => 'appeal'
  end

  map.with_options :controller => 'course' do |page|
    page.svn   'course/:action'
    page.svn   'course/:action.html'
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

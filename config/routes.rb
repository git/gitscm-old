ActionController::Routing::Routes.draw do |map|
  map.root :controller => "page"

  map.with_options :controller => 'page' do |page|
    page.about    'about', :action => 'about'
    page.docs     'documentation', :action => 'documentation'
    page.download 'download', :action => 'download'
    page.tools    'tools', :action => 'tools'
    page.manual   'manual/:command', :action => 'manual'
    page.command  'command/:command', :action => 'command'
    page.commands 'commands', :action => 'commands'
  end
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

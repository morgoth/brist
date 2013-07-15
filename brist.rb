require "sinatra"

set :reload_templates, true

helpers do
  def inline(name)
    content = erb(name)
    content.gsub("\n", '\n').gsub('"', '\"')
  end
end

get "/brist.js" do
  erb :index
end

get "/brist.css" do
  sass :brist
end

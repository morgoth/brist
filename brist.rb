require "sinatra"
require_relative "config/init"

set :erb, trim: "-"

helpers Helpers

get "/" do
  erb :home
end

get %r{^/([\d]+).js$} do |id|
  brist = Brist.new(id, params)

  content_type "text/javascript", charset: "UTF-8"
  if brist.valid?
    erb :embedable, locals: {
      deal:       brist.deal,
      dealer:     brist.dealer,
      vulnerable: brist.vulnerable,
      auction:    brist.auction
    }, layout: false
  else
    # TODO: improve
    "document.write('Something went wrong');"
  end
end

get %r{^/([\d]+)$} do |id|
  brist = Brist.new(id, params)

  if brist.valid?
    erb :brist, locals: {
      deal:       brist.deal,
      dealer:     brist.dealer,
      vulnerable: brist.vulnerable,
      auction:    brist.auction,
      query:      brist.query
    }
  else
    # TODO: improve
    "Something went wrong"
  end
end

post "/convert" do
  begin
    bbo2bridge = Bbo2bridge.new(params[:url])

    query = Rack::Utils.build_query({d: bbo2bridge.dealer, v: bbo2bridge.vulnerable, a: bbo2bridge.auction.bids.map(&:to_s).join("-")})

    redirect "#{bbo2bridge.deal.id}?#{query}"
  rescue
    erb :home, locals: {alert: "There was a problem with parsing given link"}
  end
end

get "/application.css" do
  content_type "text/css"
  sass :"stylesheets/application"
end

get "/brist.css" do
  content_type "text/css"
  sass :"stylesheets/brist"
end

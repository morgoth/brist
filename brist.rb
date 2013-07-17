require "sinatra"
require "bridge"
require_relative "lib/bbo2bridge"
require_relative "lib/brist"

ENV["BRIST_HOST"] ||= "http://localhost:9292"

helpers do
  def inline(template, options)
    content = erb(template, options)
    content.gsub("\n", '\n').gsub('"', '\"')
  end

  def bids_offset(dealer)
    case dealer
    when "W" then []
    when "N" then [""]
    when "E" then ["", ""]
    when "S" then ["", "", ""]
    end
  end

  def cards_in_suit(hand, suit)
    hand.select { |card| card.suit == suit }.map(&:value).join
  end
end

get "/" do
  erb :home
end

get "/brist/:id.js" do
  brist = Brist.new(params)

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

get "/brist/:id" do
  brist = Brist.new(params)

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
  # TODO: add validation
  bbo2bridge = Bbo2bridge.new(params[:url])

  query = {d: bbo2bridge.dealer, v: bbo2bridge.vulnerable, a: bbo2bridge.auction.bids.map(&:to_s).join(",")}.map do |k, v|
    "#{k}=#{v}"
  end.join("&")
  redirect "/brist/#{bbo2bridge.deal.id}?#{query}"
end

get "/application.css" do
  content_type "text/css"
  sass :"stylesheets/application"
end

get "/brist.css" do
  content_type "text/css"
  sass :"stylesheets/brist"
end

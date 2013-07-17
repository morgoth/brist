require "sinatra"
require "bridge"
require_relative "lib/bbo2bridge"

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
  # TODO: handle missing params and invalid values
  deal = Bridge::Deal.from_id(params[:id].to_i)

  content_type "text/javascript", charset: "UTF-8"
  erb :embedable, locals: {
    deal: deal,
    dealer: params[:d].upcase,
    vulnerable: params[:v].upcase,
    auction: Bridge::Auction.new(params[:d].upcase, params[:a].split(",").map(&:upcase))
  }, layout: false
end

get "/brist/:id" do
  # TODO: handle duplication
  deal = Bridge::Deal.from_id(params[:id].to_i)

  locals = {
    deal: deal,
    dealer: params[:d].upcase,
    vulnerable: params[:v].upcase,
    auction: Bridge::Auction.new(params[:d].upcase, params[:a].split(",").map(&:upcase)),
  }

  locals[:query] = {d: locals[:dealer], v: locals[:vulnerable], a: locals[:auction].bids.map(&:to_s).join(",")}.map do |k, v|
    "#{k}=#{v}"
  end.join("&")

  erb :brist, locals: locals
end

post "/convert" do
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

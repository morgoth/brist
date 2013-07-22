require "sinatra"
require "bridge"
require_relative "lib/bbo2bridge"
require_relative "lib/brist"

set :erb, trim: "-"

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

  def vulnerable?(vulnerable, hand)
    case vulnerable
    when "BOTH" then true
    when "NONE" then false
    when "NS", "EW" then vulnerable.include?(hand)
    end
  end

  def bid_tag(bid)
    case
    when bid.pass?   then "Pass"
    when bid.contract?
      "#{bid.level}<span class='suit-#{bid.suit}'>#{suit_symbol(bid.suit)}</span>"
    when bid.double? then "Dbl"
    when bid.redouble? then "Rdbl"
    end
  end

  def suit_symbol(suit)
    case suit
    when "C" then "&clubs;"
    when "D" then "&diams;"
    when "H" then "&hearts;"
    when "S" then "&spades;"
    else
      suit
    end
  end

  def seat_class(dealer, vulnerable, direction)
    if dealer == direction
      "dealer"
    else
      vulnerable?(vulnerable, direction) ? "vulnerable" : "non-vulnerable"
    end
  end
end

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

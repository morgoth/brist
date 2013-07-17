require "sinatra"
require "bridge"

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

get "/brist/:id.js" do
  # TODO: handle missing params and invalid values
  deal = Bridge::Deal.from_id(params[:id].to_i)

  content_type "text/javascript", charset: "UTF-8"
  erb :index, locals: {
    deal: deal,
    dealer: params[:d].upcase,
    vulnerable: params[:v].upcase,
    auction: Bridge::Auction.new(params[:d].upcase, params[:a].split(",").map(&:upcase))
  }

end

get "/brist.css" do
  content_type "text/css"
  sass :brist
end

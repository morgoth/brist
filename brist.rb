require "sinatra"
require "bridge"

helpers do
  def inline(name, options)
    content = erb(name, options)
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
end

get "/brist/:id.js" do
  deal = Bridge::Deal.from_id(params[:id].to_i)
  erb :index, locals: {
    deal: deal,
    dealer: params[:d].upcase,
    vulnerable: params[:v].upcase,
    auction: Bridge::Auction.new(params[:d].upcase, params[:a].split(",").map(&:upcase))
  }
end

get "/brist.css" do
  sass :brist
end

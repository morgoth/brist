require "addressable/uri"
require "bridge"
require "lin"
require_relative "handviewer"

class Bbo2bridge
  def initialize(url)
    @bbo_url = url
  end

  def deal
    @deal ||= Bridge::Deal.new(hands)
  end

  def auction
    @auction ||= Bridge::Auction.new(client.dealer, client.bids)
  end

  def dealer
    client.dealer
  end

  def vulnerable
    client.vulnerable
  end

  private

  def client
    @client ||= if query.has_key?("lin")
      Lin::Parser.new(query["lin"])
    else
      Handviewer.new(query)
    end
  end

  def query
    @query ||= Addressable::URI.parse(@bbo_url).query_values
  end

  def hands
    {
      n: client.n,
      e: client.e,
      s: client.s,
      w: client.w
    }
  end
end

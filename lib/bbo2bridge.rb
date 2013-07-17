require "uri"
require "rack"
require "bridge"
require_relative "handviewer"

class Bbo2bridge
  def initialize(url)
    # FIXME: investigate {} signs in url
    @bbo_url = URI.encode(URI.decode(url))
  end

  def deal
    @deal ||= Bridge::Deal.new(hands)
  end

  def auction
    @auction ||= Bridge::Auction.new(client.dealer, client.auction)
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
      # Lin.new(query["lin"])
      raise StandardError("not implemented yet")
    else
      Handviewer.new(query)
    end
  end

  def query
    @query ||= Rack::Utils.parse_query(URI.parse(@bbo_url).query)
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

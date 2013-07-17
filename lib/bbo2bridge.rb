require "uri"
require "rack"
require "bridge"
require_relative "bbo"

class Bbo2bridge
  def initialize(url)
    @bbo_url = url
  end

  def deal
    @deal ||= Bridge::Deal.new(hands)
  end

  def auction
    @auction ||= Bridge::Auction.new(bbo.dealer, bbo.auction)
  end

  def dealer
    bbo.dealer
  end

  def vulnerable
    bbo.vulnerable
  end

  private

  def bbo
    @bbo ||= BBO.new(Rack::Utils.parse_query(URI.parse(@bbo_url).query))
  end

  def hands
    {
      n: bbo.n,
      e: bbo.e,
      s: bbo.s,
      w: bbo.w
    }
  end
end

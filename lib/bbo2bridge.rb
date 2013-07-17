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
    @auction ||= Bridge::Auction.new(handviewer.dealer, handviewer.auction)
  end

  def dealer
    handviewer.dealer
  end

  def vulnerable
    handviewer.vulnerable
  end

  private

  def handviewer
    @handviewer ||= Handviewer.new(Rack::Utils.parse_query(URI.parse(@bbo_url).query))
  end

  def hands
    {
      n: handviewer.n,
      e: handviewer.e,
      s: handviewer.s,
      w: handviewer.w
    }
  end
end

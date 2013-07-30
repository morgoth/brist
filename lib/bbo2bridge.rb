require "addressable/uri"
require "net/http"
require "bridge"
require "lin"
require_relative "handviewer"

class Bbo2bridge < Struct.new(:url)
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
    @query ||= bbo_uri.query_values
  end

  def uri
    @uri ||= Addressable::URI.parse(url)
  end

  def bbo_uri
    uri.host == "tinyurl.com" ? get_tiny_uri : uri
  end

  def get_tiny_uri
    net = Net::HTTP.new(uri.host, uri.port)
    head = net.start { |http| http.head(uri.path) }
    Addressable::URI.parse(head["location"])
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

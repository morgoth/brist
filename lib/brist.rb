class Brist
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def deal
    @deal ||= Bridge::Deal.from_id(attributes[:id].to_i)
  rescue ArgumentError
  end

  def dealer
    @dealer ||= attributes[:d] && attributes[:d].upcase
  end

  def vulnerable
    @vulnerable ||= attributes[:v] && attributes[:v].upcase
  end

  def auction
    @auction ||= Bridge::Auction.new(dealer, bids)
  rescue ArgumentError
  end

  def valid?
    [deal, dealer, vulnerable, auction].all?
  end

  def query
    Rack::Utils.build_query({d: dealer, v: vulnerable, a: auction.bids.map(&:to_s).join("-")})
  end

  private

  def bids
    @bids ||= (attributes[:a] && attributes[:a].split("-").map(&:upcase)) || []
  end
end

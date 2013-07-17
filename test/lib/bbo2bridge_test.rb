require "helper"
require "bbo2bridge"

describe Bbo2bridge do
  def board_url
    "http://some-host.com?s=SKQJT98765432H9DC&w=SAH8743D9873C9654&n=SHQT65DJT6CQT8732&e=SHAKJ2DAKQ542CAKJ&d=n&v=b&b=13&a=2DDRPP3NPPP"
  end

  it "returns deal" do
    bbo2bridge = Bbo2bridge.new(board_url)
    assert_equal 49409626889022168117410273948, bbo2bridge.deal.id
  end

  it "returns auction" do
    bbo2bridge = Bbo2bridge.new(board_url)
    assert_equal ["2D", "X", "XX", "PASS", "PASS", "3NT", "PASS", "PASS", "PASS"], bbo2bridge.auction.bids.map(&:to_s)
  end
end

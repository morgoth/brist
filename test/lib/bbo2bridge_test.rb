require "helper"
require "bbo2bridge"

describe Bbo2bridge do
  def board_url
    "http://some-host.com?s=SKQJT98765432H9DC&w=SAH8743D9873C9654&n=SHQT65DJT6CQT8732&e=SHAKJ2DAKQ542CAKJ&d=n&v=b&b=13&a=2DDRPP3NPPP"
  end

  def alerted_board_url
    "http://www.bridgebase.com/tools/handviewer.html?s=ST9HJT96DJT96CT98&w=SAKQJ8643HD853CQ3&n=S52H8432DQCJ76542&e=S7HAKQ75DAK742CAK&d=e&v=o&b=14&a=1D2D!(omg)PP{what%20a%20bid}P"
  end

  def encoded_board_url
    "http://www.bridgebase.com/tools/handviewer.html?s=SJT975HJT9DT9CJT8&w=SKQHKQ75DKQ6CKQ97&n=SA62HA4DAJCA65432&e=S843H8632D875432C&d=s&v=o&b=11&i=blabla&a=2D{}3SD(%u017C%F3%u0142te%20gram)P{+hej%20hej%20buu}PP"
  end

  it "returns deal" do
    bbo2bridge = Bbo2bridge.new(board_url)
    assert_equal 49409626889022168117410273948, bbo2bridge.deal.id
  end

  it "returns auction" do
    bbo2bridge = Bbo2bridge.new(board_url)
    assert_equal ["2D", "X", "XX", "PASS", "PASS", "3NT", "PASS", "PASS", "PASS"], bbo2bridge.auction.bids.map(&:to_s)
  end

  it "returns auction with alerted bids" do
    bbo2bridge = Bbo2bridge.new(alerted_board_url)
    assert_equal ["1D", "2D", "PASS", "PASS", "PASS"], bbo2bridge.auction.bids.map(&:to_s)
  end

  it "returns auction with encoded bids" do
    bbo2bridge = Bbo2bridge.new(encoded_board_url)
    assert_equal ["2D", "3S", "X", "PASS", "PASS", "PASS"], bbo2bridge.auction.bids.map(&:to_s)
  end
end

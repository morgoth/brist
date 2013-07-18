require "helper"
require "lin"

describe Lin do
  def source
    "pn|skrzat,morgoth85,piotr59,253|st||md|3S2579H38AD458QC26,S4H24569TJQKD9CJK,S36TQH7D23TKC379Q,|rh||ah|Board 13|sv|b|mb|p|mb|1C|mb|p|mb|2H|mb|p|mb|3C|mb|p|mb|3H|mb|p|mb|3S|mb|p|mb|4C|mb|p|mb|4D|mb|p|mb|4H|mb|p|mb|4S|mb|p|mb|4N|mb|p|mb|5D|mb|d|mb|6H|mb|p|mb|p|mb|p|pc|DK|pc|DA|pc|D4|pc|D9|pc|D6|pc|D5|pc|H9|pc|D3|pc|HK|pc|H7|pc|C4|pc|HA|pc|H8|mc|12|"
  end

  it "returns players" do
    assert_equal ["skrzat", "morgoth85", "piotr59", "253"], Lin.new(source).players
  end

  it "returns auction" do
    expected = ["PASS", "1C", "PASS", "2H", "PASS", "3C", "PASS", "3H", "PASS", "3S", "PASS", "4C", "PASS", "4D", "PASS", "4H", "PASS", "4S", "PASS", "4NT", "PASS", "5D", "X", "6H", "PASS", "PASS", "PASS"]
    assert_equal expected, Lin.new(source).auction
  end

  it "returns vulnerable" do
    assert_equal "BOTH", Lin.new(source).vulnerable
  end

  it "returns s hand" do
    assert_equal ["S2", "S5", "S7", "S9", "H3", "H8", "HA", "D4", "D5", "D8", "DQ", "C2", "C6"], Lin.new(source).s
  end

  it "returns w hand" do
    assert_equal ["S4", "H2", "H4", "H5", "H6", "H9", "HT", "HJ", "HQ", "HK", "D9", "CJ", "CK"], Lin.new(source).w
  end

  it "returns n hand" do
    assert_equal ["S3", "S6", "ST", "SQ", "H7", "D2", "D3", "DT", "DK", "C3", "C7", "C9", "CQ"], Lin.new(source).n
  end

  it "returns e hand" do
    assert_equal ["SA", "SK", "SJ", "S8", "DA", "DJ", "D7", "D6", "CA", "CT", "C8", "C5", "C4"], Lin.new(source).e
  end

  it "returns dealer" do
    assert_equal "N", Lin.new(source).dealer
  end
end

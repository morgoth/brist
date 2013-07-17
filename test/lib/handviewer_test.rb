require "helper"
require "handviewer"

describe Handviewer do
  it "parses N hand" do
    handviewer = Handviewer.new("n" => "S8H98632DJ4CQ9852")
    assert_equal ["S8", "H9", "H8", "H6", "H3", "H2", "DJ", "D4", "CQ", "C9", "C8", "C5", "C2"], handviewer.n
  end

  it "parses E hand with no cards in club suit" do
    handviewer = Handviewer.new("e" => "S8H98632DQJ98542C")
    assert_equal ["S8", "H9", "H8", "H6", "H3", "H2", "DQ", "DJ", "D9", "D8", "D5", "D4", "D2"], handviewer.e
  end

  it "parses auction" do
    handviewer = Handviewer.new("a" => "2DDRPP3NPPP")
    assert_equal ["2D", "X", "XX", "PASS", "PASS", "3NT", "PASS", "PASS", "PASS"], handviewer.auction
  end
end

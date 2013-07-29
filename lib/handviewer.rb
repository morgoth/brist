# http://www.bridgebase.com/help/v2help/handviewer.html

class Handviewer
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def n
    @n ||= parse_hand(params["n"])
  end

  def e
    @e ||= parse_hand(params["e"])
  end

  def s
    @s ||= parse_hand(params["s"])
  end

  def w
    @w ||= parse_hand(params["w"])
  end

  def dealer
    @dealer ||= params["d"].upcase
  end

  def vulnerable
    @vulnerable ||= case params["v"]
    when "n" then "NS"
    when "e" then "EW"
    when "b" then "BOTH"
    else
      "NONE"
    end
  end

  def bids
    @bids ||= begin
      # Removes "!(some alert)" and "{some annotation}"
      bids = params["a"].force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
      bids = bids.gsub("!", "").gsub(/\([^)]*\)/, "").gsub(/{[^}]*}/, "")
      (bids.split(/(\d\w)|(\w)/) - [""]).map! do |bid|
        case bid.upcase
        when "P" then "PASS"
        when "D" then "X"
        when "R" then "XX"
        when /\dN/ then bid[0] + "NT"
        else
          bid.upcase
        end
      end
    end
  end

  private

  def parse_hand(hand)
     (hand.match(/S(.*?)H/)[1].split("").map { |value| "S" << value.upcase } <<
     hand.match(/H(.*?)D/)[1].split("").map { |value| "H" << value.upcase } <<
     hand.match(/D(.*?)C/)[1].split("").map { |value| "D" << value.upcase } <<
     hand.match(/C(.*?)$/)[1].split("").map { |value| "C" << value.upcase }).flatten
  end
end

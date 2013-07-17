class BBO
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
    when "o" then "NONE"
    when "n" then "NS"
    when "e" then "EW"
    when "b" then "BOTH"
    end
  end

  def auction
    @auction ||= (params["a"].split(/(\d\w)|(\w)/) - [""]).map! do |bid|
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

  private

  def parse_hand(hand)
     (hand.match(/S(.*?)H/)[1].split("").map { |value| "S" << value.upcase } <<
     hand.match(/H(.*?)D/)[1].split("").map { |value| "H" << value.upcase } <<
     hand.match(/D(.*?)C/)[1].split("").map { |value| "D" << value.upcase } <<
     hand.match(/C(.*?)$/)[1].split("").map { |value| "C" << value.upcase }).flatten
  end
end

# Rack::Utils.parse_query URI.parse(c).query

# {"sn"=>"fkzyw2", "s"=>"ST73HAKQTDQCJT764", "wn"=>"morgoth85", "w"=>"SAQ642H5DAT9863CA",
# "nn"=>"ju28", "n"=>"S8H98632DJ4CQ9852", "en"=>"253", "e"=>"SKJ95HJ74DK752CK3", "d"=>"n", "v"=>"o", "b"=>"1",
# "a"=>"PP2C2S3C3S4C4S5CPPP", "p"=>"SAS8S5S3DAD4D2DQD6DJDKC6CJCAC2C3S2C9S9S7CQCKC4D8H7HKH5H2", "c"=>"9"}

module Helpers
  def inline(template, options)
    content = erb(template, options)
    content.gsub("\n", '\n').gsub('"', '\"')
  end

  def bids_offset(dealer)
    case dealer
    when "W" then []
    when "N" then [""]
    when "E" then ["", ""]
    when "S" then ["", "", ""]
    end
  end

  def cards_in_suit(hand, suit)
    hand.select { |card| card.suit == suit }.map(&:value).join
  end

  def vulnerable?(vulnerable, hand)
    case vulnerable
    when "BOTH" then true
    when "NONE" then false
    when "NS", "EW" then vulnerable.include?(hand)
    end
  end

  def bid_tag(bid)
    case
    when bid.pass?   then "Pass"
    when bid.contract?
      "#{bid.level}<span class='suit-#{bid.suit}'>#{suit_symbol(bid.suit)}</span>"
    when bid.double? then "Dbl"
    when bid.redouble? then "Rdbl"
    end
  end

  def suit_symbol(suit)
    case suit
    when "C" then "&clubs;"
    when "D" then "&diams;"
    when "H" then "&hearts;"
    when "S" then "&spades;"
    else
      suit
    end
  end

  def seat_class(dealer, vulnerable, direction)
    if dealer == direction
      "dealer"
    else
      vulnerable?(vulnerable, direction) ? "vulnerable" : "non-vulnerable"
    end
  end
end

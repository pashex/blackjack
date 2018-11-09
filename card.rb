class Card
  SUITS = %w[♥ ♦ ♣ ♠].freeze
  attr_reader :name

  def initialize(suit, value)
    @name = "#{value}#{suit}"
  end

  def points
    return 11 if ace?
    return 10 if pic?

    name[0..-2].to_i
  end

  def ace?
    name[0] == 'Т'
  end

  private

  def pic?
    %w[В Д К].include?(name[0])
  end
end

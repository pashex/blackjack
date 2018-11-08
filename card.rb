class Card
  SUITS = %w[♥ ♦ ♣ ♠].freeze
  VALUES = ['Т', (2..10).to_a, %w[В Д К]].flatten
  DECK = SUITS.map { |suit| VALUES.map { |v| "#{v}#{suit}" } }.flatten.freeze

  attr_reader :name

  def self.sum_points(cards)
    base_sum = cards.sum(&:base_points)
    cards.select(&:ace?).each do
      base_sum -= 10 if base_sum > 21
    end
    base_sum
  end

  def initialize(name)
    @name = name
  end

  def base_points
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

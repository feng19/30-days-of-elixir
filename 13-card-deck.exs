defmodule Deck do
  @moduledoc """
    Create, shuffle, deal a set of 52 cards.
  """

  @doc """
    Returns a list of tuples, in sorted order.
  """
  def new do
    for suit <- ~w(Hearts Clubs Diamonds Spades),
        face <- [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"],
        do: {suit, face}
  end

  @doc """
    Given a list of cards (a deck), reorder cards randomly.

    If no deck is given, then create a new one and shuffle that.
  """
  def shuffle(deck \\ new()) do
    Enum.shuffle(deck)
  end

  @doc """
    Given a deck of cards, a list of players, and a deal function,
    call the deal function for each card for each player. The function
    should return the updated player.

    Returns the list of players.
  """

  def deal(cards, players, deal_fn, cards_per_player \\ 52) do
    cards_left = cards_per_player * Enum.count(players)
    _deal(cards, players, deal_fn, cards_left)
  end

  def _deal(cards, players, _, 0), do: {players, cards}

  def _deal([card | rest_cards], [player | rest_players], deal_fn, cards_left) do
    player = deal_fn.(card, player)
    _deal(rest_cards, rest_players ++ [player], deal_fn, cards_left - 1)
  end

  def _deal([], players, _, _), do: {players, []}


end

ExUnit.start

defmodule DeckTest do
  use ExUnit.Case

  test "new" do
    deck = Deck.new()
    assert Enum.at(deck, 0) == {"Hearts", 2}
    assert Enum.at(deck, 51) == {"Spades", "A"}
  end

  test "shuffle" do
    :random.seed(:erlang.now)
    deck = Deck.shuffle()
    assert Deck.shuffle() != deck
    assert length(Deck.shuffle) == 52
  end

  test "deal" do
    players = [tim: [], jen: [], mac: [], kai: []]
    deck = Deck.new()
    {players, deck} = Deck.deal(deck, players, fn (card, {name, cards}) -> {name, [card | cards]} end)
    assert Keyword.get(players, :tim) == [
             {"Spades", "J"},
             {"Spades", 7},
             {"Spades", 3},
             {"Diamonds", "Q"},
             {"Diamonds", 8},
             {"Diamonds", 4},
             {"Clubs", "K"},
             {"Clubs", 9},
             {"Clubs", 5},
             {"Hearts", "A"},
             {"Hearts", 10},
             {"Hearts", 6},
             {"Hearts", 2}
           ]
    assert Keyword.get(players, :jen) == [
             {"Spades", "Q"},
             {"Spades", 8},
             {"Spades", 4},
             {"Diamonds", "K"},
             {"Diamonds", 9},
             {"Diamonds", 5},
             {"Clubs", "A"},
             {"Clubs", 10},
             {"Clubs", 6},
             {"Clubs", 2},
             {"Hearts", "J"},
             {"Hearts", 7},
             {"Hearts", 3}
           ]
    assert Keyword.get(players, :mac) == [
             {"Spades", "K"},
             {"Spades", 9},
             {"Spades", 5},
             {"Diamonds", "A"},
             {"Diamonds", 10},
             {"Diamonds", 6},
             {"Diamonds", 2},
             {"Clubs", "J"},
             {"Clubs", 7},
             {"Clubs", 3},
             {"Hearts", "Q"},
             {"Hearts", 8},
             {"Hearts", 4}
           ]
    assert Keyword.get(players, :kai) == [
             {"Spades", "A"},
             {"Spades", 10},
             {"Spades", 6},
             {"Spades", 2},
             {"Diamonds", "J"},
             {"Diamonds", 7},
             {"Diamonds", 3},
             {"Clubs", "Q"},
             {"Clubs", 8},
             {"Clubs", 4},
             {"Hearts", "K"},
             {"Hearts", 9},
             {"Hearts", 5}
           ]
    assert deck == []
  end

  test "deal 5 cards per player" do
    players = [tim: [], jen: [], mac: [], kai: []]
    deck = Deck.new()
    {players, deck} = Deck.deal(deck, players, fn (card, {name, cards}) -> {name, [card | cards]} end, 5)
    assert Keyword.get(players, :tim) == [{"Clubs", 5}, {"Hearts", "A"}, {"Hearts", 10}, {"Hearts", 6}, {"Hearts", 2}]
    assert Keyword.get(players, :jen) == [{"Clubs", 6}, {"Clubs", 2}, {"Hearts", "J"}, {"Hearts", 7}, {"Hearts", 3}]
    assert Keyword.get(players, :mac) == [{"Clubs", 7}, {"Clubs", 3}, {"Hearts", "Q"}, {"Hearts", 8}, {"Hearts", 4}]
    assert Keyword.get(players, :kai) == [{"Clubs", 8}, {"Clubs", 4}, {"Hearts", "K"}, {"Hearts", 9}, {"Hearts", 5}]
    assert Keyword.keys(players) == [:tim, :jen, :mac, :kai]
    [next | _rest_of_deck] = deck
    assert next == {"Clubs", 9}
  end
end

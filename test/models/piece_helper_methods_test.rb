require 'test_helper'

# Tests for Piece logic helper methods
class PieceTest < ActiveSupport::TestCase
  test 'color name' do
    piece = FactoryGirl.create(:pawn)

    piece.color = 1

    assert_equal 'white', piece.color_name
  end

  test 'setting default images' do
    piece = FactoryGirl.create(:pawn)
    piece.color = 0

    assert_equal 'black-pawn.gif', piece.symbol
  end

  test 'move on board' do
    piece = FactoryGirl.create(:pawn)

    assert_equal true, piece.move_on_board?(3, 0)
  end

  test 'move is not on board' do
    piece = FactoryGirl.create(:pawn)

    assert_equal false, piece.move_on_board?(9, 0)
  end

  test 'should not capture' do
    game = FactoryGirl.create(:game)
    piece = FactoryGirl.create(
      :rook,
      x_position: 5,
      y_position: 4,
      color: true,
      game_id: game.id)
    FactoryGirl.create(
      :pawn,
      x_position: 5,
      y_position: 5,
      color: true,
      game_id: game.id)

    assert_not piece.capture_move?(5, 5), 'Is not a capture move'
  end

  test 'should capture' do
    game = FactoryGirl.create(:game)
    piece = FactoryGirl.create(
      :rook,
      x_position: 5,
      y_position: 4,
      color: true,
      game_id: game.id)
    FactoryGirl.create(
      :pawn,
      x_position: 5,
      y_position: 5,
      color: false,
      game_id: game.id)

    assert piece.capture_move?(5, 5), 'Is a capture move'
  end

  test 'should mark piece as captured' do
    piece = FactoryGirl.create(
      :rook,
      x_position: 5,
      y_position: 4)
    piece.mark_captured
    piece.reload

    assert_nil piece.x_position, 'Should be x_position: nil'
    assert_nil piece.y_position, 'Should be y_position: nil'
    assert_equal 'captured', piece.state
  end

  test 'should not be a move' do
    piece = FactoryGirl.create(:rook, x_position: 5, y_position: 4)

    assert piece.nil_move?(5, 4)
    assert_not piece.nil_move?(5, 5)
  end

  test 'destination should be obstructed' do
    game = FactoryGirl.create(:game)
    piece = FactoryGirl.create(
      :rook,
      x_position: 5,
      y_position: 4,
      color: true,
      game_id: game.id)

    assert piece.destination_obstructed?(5, 1), 'not obstructed '
    assert_not piece.destination_obstructed?(5, 6), 'not obstructed'
    assert_not piece.destination_obstructed?(5, 9), 'Not obstructed'
  end
end
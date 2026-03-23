class GamesController < ApplicationController
  before_action :set_game

  def show
    @user_team = @game.user_team(Current.user)
    @user_rsvp = @game.rsvps.find_by(user: Current.user)
    @is_captain = Current.user.captain_in_game?(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end

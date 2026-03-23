class ScoresController < ApplicationController
  before_action :set_game
  before_action :authorize_captain

  def update
    if @game.cancelled?
      redirect_to game_path(@game), alert: "Cannot enter scores for a cancelled game."
      return
    end

    @game.assign_attributes(score_params)
    @game.status = :completed

    if @game.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("game_#{@game.id}_score",
              partial: "games/score_display",
              locals: { game: @game }),
            turbo_stream.replace("game_#{@game.id}_score_form",
              partial: "games/score_form",
              locals: { game: @game, is_captain: true })
          ]
        }
        format.html { redirect_to game_path(@game), notice: "Score saved." }
      end
    else
      redirect_to game_path(@game), alert: "Could not save score."
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def authorize_captain
    unless Current.user.captain_in_game?(@game)
      redirect_to game_path(@game), alert: "Only captains can enter scores." and return
    end
  end

  def score_params
    params.expect(score: [ :home_score, :away_score ])
  end
end

class RsvpsController < ApplicationController
  before_action :set_game
  before_action :authorize_rsvp
  before_action :validate_response_param
  before_action :enforce_rsvp_deadline

  def create
    @rsvp = @game.rsvps.build(user: Current.user, response: params[:response], responded_at: Time.current)

    if @rsvp.save
      respond_to do |format|
        format.turbo_stream { render_rsvp_stream }
        format.html { redirect_to game_path(@game) }
      end
    else
      redirect_to game_path(@game), alert: "Could not save RSVP."
    end
  end

  def update
    @rsvp = @game.rsvps.find_by(user: Current.user)

    unless @rsvp
      redirect_to game_path(@game), alert: "No RSVP found to update."
      return
    end

    @rsvp.update!(response: params[:response], responded_at: Time.current)

    respond_to do |format|
      format.turbo_stream { render_rsvp_stream }
      format.html { redirect_to game_path(@game) }
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def authorize_rsvp
    unless @game.user_team(Current.user)
      redirect_to game_path(@game), alert: "You are not on a team in this game." and return
    end
  end

  def validate_response_param
    allowed = %w[yes no maybe]
    unless allowed.include?(params[:response])
      redirect_to game_path(@game), alert: "Invalid RSVP response." and return
    end
  end

  def enforce_rsvp_deadline
    if @game.rsvp_deadline_passed?
      redirect_to game_path(@game), alert: "The RSVP deadline has passed." and return
    end
  end

  def render_rsvp_stream
    @user_team = @game.user_team(Current.user)
    render turbo_stream: [
      turbo_stream.replace("game_#{@game.id}_rsvp_buttons",
        partial: "games/rsvp_buttons",
        locals: { game: @game, rsvp: @rsvp, user_team: @user_team }),
      turbo_stream.replace("game_#{@game.id}_rsvp_counts",
        partial: "games/rsvp_counts",
        locals: { game: @game, team: @user_team }),
      turbo_stream.replace("game_#{@game.id}_roster",
        partial: "games/roster",
        locals: { game: @game, team: @user_team })
    ]
  end
end

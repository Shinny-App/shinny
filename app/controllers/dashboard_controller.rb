class DashboardController < ApplicationController
  def show
    if Current.user.teams.any?
      @upcoming_games = Current.user.upcoming_games.includes(:home_team, :away_team, :location, :league, :rsvps)
      @past_games = Current.user.past_games.includes(:home_team, :away_team, :location, :league).limit(20)
    end
  end
end

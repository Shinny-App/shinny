class LeaguesController < ApplicationController
  def standings
    @league = League.find(params[:id])
    @standings = @league.standings
  end
end

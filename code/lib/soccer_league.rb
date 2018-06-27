require 'erb'

class League
  attr_reader :teams
  
  # teams is a hash where the key is the team name and the value is a Team object
  def initialize
    @teams = {}
  end
  
  # this is here just for fun
  def team_names
    @teams.keys
    
  end
  
  # the input is a string formatted like this:
  # "(TEAM 1 NAME) (TEAM 1 SCORE), (TEAM 2 NAME) (TEAM 1 SCORE)"
  # ex
  # 'Tarantulas 1, FC Awesome 0'
  def play_match( match_results )
    team_1_results, team_2_results = match_results.split(', ').map { |s| team_name_and_score(s) }
    
    @teams[team_1_results[:name]] ||= Team.new(team_1_results[:name])
    @teams[team_2_results[:name]] ||= Team.new(team_2_results[:name])
    
    @teams[team_1_results[:name]].play_match( team_1_results[:score], team_2_results[:score], team_2_results[:name] )
    @teams[team_2_results[:name]].play_match( team_2_results[:score], team_1_results[:score], team_1_results[:name] )
  end
  
  def sort_teams
    sorted_teams = teams.values.sort do |a, b| 
      [b.pts, a.name] <=> [a.pts, b.name]
    end
    
    standing = 0
    previous_point_total = nil
    count = 0

    sorted_teams.each do |team|
      count += 1
      if team.pts != previous_point_total
        standing = count
      end
      previous_point_total = team.pts
      
      yield( team, standing )
    end
  end
  
  def standings
    standings = []
    
    sort_teams do |team, standing|
      standings << "#{ standing }. #{team.name}, #{team.pts} #{ (team.pts == 1 ? 'pt' : 'pts' )}"
    end
    
    standings.join("\n")
  end
  
  private
  
  # this takes a string with a team name and a score and returns a hash with
  # the name as a string and the score as an integer
  # ex input: 'Raging Peanuts 3'
  # ex output: { name: 'Raging Peanuts', score: 3 }
  def team_name_and_score( string )
    result = string.split(' ')
    
    # the last value should be the score
    score = result.pop.to_i
    
    # join whatever is left over
    name = result.join(" ")
    
    { name: name, score: score }
  end
  
  
  
  public
  
  include ERB::Util
  
  def overview_page
    %{
      <html>
        <head><title>Soccer League!</title></head>
        <body>
          <h2>Standings Overview</h2>
          <table>
            <tr>
              <th>Pos.</th>
              <th>Team</th>
              <th>MP</th>
              <th>W</th>
              <th>D</th>
              <th>L</th>
              <th>GF</th>
              <th>GA</th>
              <th>GD</th>
              <th>Pts</th>
            </tr>
            <% sort_teams do |team, standing| %>
              <tr>
                <td><%= standing %></td>
                <td><a href="<%= team.name.downcase.gsub(' ', '_')%>_games.html"><%= team.name %></a></td>
                <td><%= team.mp %></td>
                <td><%= team.w %></td>
                <td><%= team.d %></td>
                <td><%= team.l %></td>
                <td><%= team.gf %></td>
                <td><%= team.ga %></td>
                <td><%= team.gd %></td>
                <td><%= team.pts %></td>
              </tr>
            <% end %>
          </table>
        </body>
      </html>
    }
  end
  
  def team_page(team)
    %{
      <html>
      <head><title>Soccer League!</title></head>
      <body>
        <h2><%= team.name %> Matches</h2>
        <table>
          <% team.matches.each do |match| %>
            <tr>
              <td><a href="<%= team.name.downcase.gsub(' ', '_')%>_games.html"><%= team.name %></a></td>
              <td><%= match[:team_score] %></td>
              <td><%= match[:opponent_score] %></td>
              <td><a href="<%= match[:opponent_name].downcase.gsub(' ', '_')%>_games.html"><%= match[:opponent_name] %></a></td>
            </tr>
          <% end %>
        </table>
        <p><a href="league_standings.html">Home</a></p>
      </body>
      </html>
    }
  end
  
  # This page helped me understand ERB rendering
  # http://www.stuartellis.name/articles/erb/
  def save
    require 'fileutils'
    
    FileUtils.mkdir_p(File.dirname('./html_standings/.'))
    
    File.open('./html_standings/league_standings.html', "w+") do |f|
      f.write(ERB.new(overview_page).result(binding))
    end
    
    teams.values.each do |team|
      File.open("./html_standings/#{team.name.downcase.gsub(' ', '_')}_games.html", "w+") do |f|
        f.write(ERB.new(team_page(team)).result(binding))
      end
    end
  end
  
end

class Team
  attr_accessor :name
  
  attr_reader :w, :d, :l, :gf, :ga
  
  # w - wins
  # d - draws
  # l - losses
  # gf - goals for
  # ga - goals against
  
  attr_reader :matches
  
  def initialize(name)
    # start with all the stats to zero
    @mp = @w = @l = @d = @gf = @ga = 0
    @name = name
    
    @matches = []
  end
  
  def play_match( team_score, opponent_score, opponent_name = 'opponent' )
    @matches << {
      team_score: team_score,
      opponent_score: opponent_score,
      opponent_name: opponent_name
    }
    
    # record goals for
    @gf += team_score
    
    # record goals against
    @ga += opponent_score
    
    # record win, loss or draw
    if team_score > opponent_score
      @w += 1
    elsif team_score == opponent_score
      @d += 1
    else
      @l += 1
    end
  end
  
  # mp - matches played
  # matches played is the sum of wins, losses and draws
  def mp
    w + l + d
  end
  
  # gd - goal difference
  # goal difference is goals for minus goals allowed
  def gd 
    gf - ga
  end
  
  # pts - league points
  # leagues points are awarded as follows: 3 points for a win, 1 point for a draw, 0 points for a loss
  # TODO - this might need to be refactored into the league since different leagues might have different scoring systems
  def pts
    ( w * 3 ) + d
  end
end
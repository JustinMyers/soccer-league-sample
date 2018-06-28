require 'minitest/autorun'
require_relative '../lib/soccer_league.rb'

describe League, 'at the start of the season' do
  let(:league) { League.new }
  
  it 'should have no teams' do
    league.team_names.must_be_empty
  end
end

describe League, 'after one drawn match' do
  let(:league) do
    l = League.new
    l.play_match('Lions 3, Snakes 3')
    l
  end
  
  it 'should have two teams, both with 1 league point' do
    league.team_names.length.must_equal 2
    league.team_names.must_include 'Lions'
    league.team_names.must_include 'Snakes'

    league.teams['Lions'].pts.must_equal 1
    league.teams['Snakes'].pts.must_equal 1
  end
  
  it 'should output tied rankings in alphabetical order' do
    league.standings.must_equal "1. Lions, 1 pt\n1. Snakes, 1 pt"
  end
end

describe League, 'after the whole season' do
  let(:league) do
    l = League.new
    l.play_match('Lions 3, Snakes 3')
    l.play_match('Tarantulas 1, FC Awesome 0')
    l.play_match('Lions 1, FC Awesome 1')
    l.play_match('Tarantulas 3, Snakes 1')
    l.play_match('Lions 4, Grouches 0')
    l
  end
  
  it 'should output tied rankings in alphabetical order' do
    league.standings.must_equal "1. Tarantulas, 6 pts\n2. Lions, 5 pts\n3. FC Awesome, 1 pt\n3. Snakes, 1 pt\n5. Grouches, 0 pts"
  end
end

describe League, 'a STRICT league after the whole season' do
  let(:league) do
    l = League.new( true ) # this is for a STRICT league
    l.play_match('Lions 3, Snakes 3')
    l.play_match('Tarantulas 1, FC Awesome 0')
    l.play_match('Lions 1, FC Awesome 1')
    l.play_match('Tarantulas 3, Snakes 1')
    l.play_match('Lions 4, Grouches 0')
    l
  end
  
  it 'should output tied POINTS rankings in order of GOAL DIFFERENCE' do
    league.standings.must_equal "1. Tarantulas, 6 pts\n2. Lions, 5 pts\n3. FC Awesome, 1 pt\n4. Snakes, 1 pt\n5. Grouches, 0 pts"
  end
end

describe Team, 'at the start of the season' do
  let(:team) { Team.new('Developers') }

  describe 'when asked its name' do
    it 'will know what it is called' do 
      team.name.must_equal 'Developers'
    end
  end
  
  describe 'before it plays a match' do
    it 'will have zero matches played' do
      team.mp.must_equal 0
    end
    
    it 'will have zero wins' do
      team.w.must_equal 0
    end
    
    it 'will have zero draws' do
      team.d.must_equal 0
    end
    
    it 'will have zero losses' do
      team.l.must_equal 0
    end
  end
end

describe Team, 'when it loses a match 4 to 7' do
  let(:team) do
    t = Team.new('Developers')
    t.play_match( 4, 7 )
    t
  end
  
  it 'will update its matches played' do
    team.mp.must_equal 1
  end

  it 'will have recorded its goals for tally' do
    team.gf.must_equal 4
  end

  it 'will have recorded its goals allowed tally' do
    team.ga.must_equal 7
  end

  it 'will have given itself a loss' do
    team.l.must_equal 1
  end
  
  it 'will have a negative goal difference' do
    team.gd.must_equal( -3 )
  end
  
  it 'will have league 0 points' do
    team.pts.must_equal 0
  end
end

describe Team, 'when it wins a match 3 to 0' do
  let(:team) do
    t = Team.new('Developers')
    t.play_match( 3, 0 )
    t
  end
  
  it 'will have given itself a win' do
    team.w.must_equal 1
  end
  
  it 'will not have given itself a loss or draw' do
    team.l.must_equal 0
    team.d.must_equal 0
  end
  
  it 'will have a positive goal difference' do
    team.gd.must_equal 3
  end
  
  it 'will have league 3 points' do
    team.pts.must_equal 3
  end
end

describe Team, 'when it wins a match and draws a match' do
  let(:team) do
    t = Team.new('Developers')
    t.play_match( 3, 0 )
    t.play_match( 1, 1 )
    t
  end
  
  it 'will have given itself a win and a draw' do
    team.w.must_equal 1
    team.d.must_equal 1
  end
  
  it 'will not have given itself a loss' do
    team.l.must_equal 0
  end
  
  it 'will have played two matches' do
    team.mp.must_equal 2
  end
  
  it 'will have a positive goal difference' do
    team.gd.must_equal 3
  end
  
  it 'will have league 4 points' do
    team.pts.must_equal 4
  end
end

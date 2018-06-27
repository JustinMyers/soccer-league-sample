require './lib/soccer_league.rb'

lines = ARGF.readlines

league = League.new

lines.each do |line|
  league.play_match(line)
end

puts league.standings

league.save
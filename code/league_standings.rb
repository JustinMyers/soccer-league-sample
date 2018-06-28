require './lib/soccer_league.rb'

html_output = false
strict_standings = false

if ARGV.include?('--html')
  ARGV.replace( ARGV - ['--html'] )
  html_output = true
end

# Strict standings causes the League to use goal difference to break point ties.
if ARGV.include?('--strict')
  ARGV.replace( ARGV - ['--strict'] )
  strict_standings = true
end

lines = ARGF.readlines

league = League.new( strict_standings )

lines.each do |line|
  league.play_match(line)
end

puts league.standings

league.save if html_output
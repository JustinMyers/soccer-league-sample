## Instructions


#### Pipe in results
➜ cat sample-input.txt | ruby league_standings.rb
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
3. Snakes, 1 pt
5. Grouches, 0 pts

#### List files as parameters
➜ ruby league_standings.rb sample-input.txt
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
3. Snakes, 1 pt
5. Grouches, 0 pts

#### Redirect
➜ ruby league_standings.rb < sample-input.txt
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
3. Snakes, 1 pt
5. Grouches, 0 pts

#### If no file or STDIN is provided you can type in results
➜ ruby league_standings.rb
Lions 3, Snakes 3
Tarantulas 1, FC Awesome 0
Lions 1, FC Awesome 1
Tarantulas 3, Snakes 1
Lions 4, Grouches 0
1. Tarantulas, 6 pts
2. Lions, 5 pts
3. FC Awesome, 1 pt
3. Snakes, 1 pt
5. Grouches, 0 pts

#### You can list multiple files
➜ ruby league_standings.rb sample-input.txt sample-input.txt
1. Tarantulas, 12 pts
2. Lions, 10 pts
3. FC Awesome, 2 pts
3. Snakes, 2 pts
5. Grouches, 0 pts
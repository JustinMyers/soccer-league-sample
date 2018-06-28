## Soccer League Code Sample

### Basic usage

git clone https://github.com/JustinMyers/soccer-league-sample.git  
cd soccer-league-sample/code  
bundle (install the bundler gem if you need to)  
rake (run the tests)  
ruby league_standings.rb sample-input.txt (try the script)  

### Development

All development happens in the code directory.

The Gemfile provided has some testing faclities in it. The tests can be run by calling `bundle exec rake` from the code directory. Running guard with `bundle exec guard` will run the tests when a file is changed.

The league_standings.rb file is not tested. It is quite small and I didn't have a good strategy for testing it.

### Silliness

With the --html flag you can force the script to output some HTML files which show the matches and standings.

With the --strict flag you can force the script to use the goal difference stat to break point ties.

### Instructions

From inside the code directory:

#### Pipe in results
➜ cat sample-input.txt | ruby league_standings.rb

#### List files as parameters
➜ ruby league_standings.rb sample-input.txt

#### Redirect
➜ ruby league_standings.rb < sample-input.txt

#### If no file or STDIN is provided you can type in results
➜ ruby league_standings.rb  
Lions 3, Snakes 3  
Tarantulas 1, FC Awesome 0  
Lions 1, FC Awesome 1  
Tarantulas 3, Snakes 1  
Lions 4, Grouches 0  
CTRL+D

#### You can list multiple files
➜ ruby league_standings.rb sample-input.txt sample-input.txt
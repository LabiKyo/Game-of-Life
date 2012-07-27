fs = require 'fs'
{exec} = require 'child_process'

sty = require 'sty'

# compile
compile = (type, description, script) ->
  task "compile:#{type}", description, ->
    exec script, (err, output) ->
      if err
        console.log sty.red(err)
      else
        console.log sty.green("#{type} compiled")

compile 'jade', 'compile jade to html', 'jade -O public src/jade/index.jade'

compile 'coffee', 'compile coffee-script to javascript', 'coffee -bj public/js/main.js -c src/coffee/main.coffee'

compile 'stylus', 'compile stylus to css', 'stylus -u nib -o public/css/ -c src/styl/main.styl'

task 'compile', 'compile all source codes', ->
  invoke 'compile:jade'
  invoke 'compile:stylus'
  invoke 'compile:coffee'

# watch
task 'watch', 'watch file changes and auto run compile tasks', ->
  invoke 'compile'
  fs.watch './src/coffee', (event, filename) ->
    invoke 'compile:coffee'

  fs.watch './src/styl', (event, filename) ->
    invoke 'compile:stylus'

  fs.watch './src/jade', (event, filename) ->
    invoke 'compile:jade'

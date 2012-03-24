#!/usr/bin/env node

sug = require './suggest'
argv = require('optimist')
  .usage('Suggest queries from Google.\nUsage: $0 [query]')
  .alias('i', 'interactive')
  .describe('i', 'Search as you type')
  .argv

exports.run = ->
  if argv.i
    sug.interactive()
  else
    sug.suggest argv._.join(' '), (results) ->
      sug.print results

# vim:ft=coffee ts=2 sw=2 et :

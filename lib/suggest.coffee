#!/usr/bin/env node

sys = require("util")
colors = require("colors")
rest = require("restler")
_ = require("underscore")
argv = require("optimist")
    .usage('Suggest queries from Google.\nUsage: $0 [query]')
    .alias('i', 'interactive')
    .describe('i', 'Search as you type')
    .argv

class Suggest
  constructor: () ->
    @url = "https://www.google.com/s"
    _.templateSettings = interpolate: /\{\{(.+?)\}\}/g
  suggest: (query) ->
    rest.get(@url,
      query: q: query
      parser: (data, cb) ->
        cb JSON.parse(data.replace("window.google.ac.h", "").replace(/\((.+?)\)/g, "$1"))[1]
    ).on "complete", (result, response) ->
      sys.puts result.message.toString().red if result instanceof Error
      unless result instanceof Error
        _.each result, (term) ->
          sys.puts _.template("※  {{ term }}")(term: term[0].green)
  interactive: ->
    t = this
    q = ''
    chrm = require("charm")(process)
    chrm
      .reset()
      .cursor(false)
      .write('➡ '.blue)
      .on("^C", process.exit)
      .on('^D', ->
         q = ''
         chrm.reset()
          .write('➡ '.blue))
      .on("data", (c) ->
         q = q.substring(0, q.length - 1) if c[0] == 127
         q += c unless c[0] == 127
         chrm
           .reset()
           .write(_.template("{{ prompt }} {{ term }}")(prompt: '➡'.blue, term: q.red))
           .position(0, 3)
         t.suggest q if q.length > 0)

sug = new Suggest

if argv.i
  sug.interactive()
else
  sug.suggest(argv._.join(" "))


# vim:ft=coffee ts=2 sw=2 et :

#!/usr/bin/env node

sys = require("util")
colors = require("colors")
rest = require("restler")
_ = require("underscore")
async = require("async")
argv = require("optimist")
    .usage('Suggest queries from Google.\nUsage: $0 [query]')
    .alias('i', 'interactive')
    .describe('i', 'Search as you type')
    .argv

class Suggest
  constructor: () ->
    @url = "https://www.google.com/s"
    _.templateSettings = interpolate: /\{\{(.+?)\}\}/g
  suggest: (query, cb) ->
    rest.get(@url,
      query: q: query
      parser: (data, pcb) ->
        pcb JSON.parse(data.replace("window.google.ac.h", "").replace(/\((.+?)\)/g, "$1"))[1]
    ).on "complete", (result, response) ->
      sys.puts result.message.toString().red if result instanceof Error
      cb(result) unless result instanceof Error
  print: (results) ->
    _.each results, (term) ->
      sys.puts _.template("※  {{ term }}")(term: term[0].green)
  interactive: ->
    t = this
    q = ''
    chrm = require("charm")(process)
    chrm
      .cursor(false)
      .reset()
      .write('➡ _'.blue)
      .on("^C", process.exit)
      .on('^D', ->
         q = ''
         chrm.reset()
          .write('➡ _'.blue))
      .on("data", (c) ->
         q = q.substring(0, q.length - 1) if c[0] == 127
         q += c unless c[0] == 127
         async.series([
             (cb) ->
               cb(null, []) unless q.length > 0
               t.suggest(q, (results) ->
                 cb(null, results)
               ) if q.length > 0
           , (cb) ->
             chrm
               .reset()
               .write(_.template("{{ prompt }} {{ term }}_")(prompt: '➡'.blue, term: q.red))
               .position(0, 3)
             cb(null, [])
           ], (err, results) ->
             t.print results[0]
         ))

sug = new Suggest

if argv.i
  sug.interactive()
else
  sug.suggest argv._.join(" "), (results) ->
    sug.print results

# vim:ft=coffee ts=2 sw=2 et :

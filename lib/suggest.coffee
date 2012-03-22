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

_.templateSettings = interpolate: /\{\{(.+?)\}\}/g

fetch = (query) ->
    rest.get("https://www.google.com/s", query: 
      sugexp: "pfwl"
      q: query
    ).on "complete", (result, response) ->
      if result instanceof Error
        sys.puts "Error: " + result.message
      else
        _.each JSON.parse(result.replace("window.google.ac.h", "").replace(/\((.+?)\)/g, "$1"))[1], (term) ->
          sys.puts _.template("※  {{ term }}")(term: term[0].green)

if argv.i
    charm = require("charm")(process)
    q = ''
    charm
        .reset()
        .cursor(false)
        .move(0, 0)
        .foreground('red')
        .write('➡ '.blue)
        .on("^C", process.exit)
        .on('^D', ->
            q = ''
            charm.reset())
        .on("data", (c) ->
            q = q.substring(0, q.length - 1) if c[0] == 127
            q += c unless c[0] == 127
            charm
                .reset()
                .move(0, 0)
                .foreground('red')
                .write('➡ '.blue + q)
                .position(0, 3)
            fetch q if q.length > 0)
else
    fetch(argv._.join(" "))

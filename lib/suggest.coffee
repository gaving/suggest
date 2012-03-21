#!/usr/bin/env node

sys = require("util")
colors = require("colors")
rest = require("restler")
_ = require("underscore")
argv = require("optimist").argv

_.templateSettings = interpolate: /\{\{(.+?)\}\}/g
query = argv._.join(" ")

rest.get("http://www.google.com/s", query: 
  sugexp: "pfwl"
  cp: "15"
  q: query
).on "complete", (result, response) ->
  if result instanceof Error
    sys.puts "Error: " + result.message
  else
    _.each JSON.parse(result.replace("window.google.ac.h", "").replace(/\((.+?)\)/g, "$1"))[1], (term) ->
      sys.puts _.template("ツ {{ term }}")(term: term[0].green)

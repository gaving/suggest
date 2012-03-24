vows = require 'vows'
assert = require 'assert'
_      = require 'underscore'
sug = require '../lib/suggest'

vows
  .describe('fetches results')
  .addBatch
    'check suggestions':
      topic: sug
      'for kanye west':
        topic: (sug) ->
          sug.suggest 'kanye west is', this.callback
          return
        'has results': (results, err) ->
          assert.isArray results
          assert.isNotEmpty results
        'match the subject': (results, err) ->
          _.each results, (term) ->
            assert.match(term[0], /kanye/)

      'for wolf parade':
        topic: (sug) ->
          sug.suggest 'wolf parade are', this.callback
          return
        'has results': (results, err) ->
          assert.isArray results
          assert.isNotEmpty results
        'match the subject': (results, err) ->
          _.each results, (term) ->
            assert.match(term[0], /wolf/)

      'for lana del rey':
        topic: (sug) ->
          sug.suggest 'is lana del rey', this.callback
          return
        'has results': (results, err) ->
          assert.isArray results
          assert.isNotEmpty results
        'match the subject': (results, err) ->
          _.each results, (term) ->
            assert.match(term[0], /lana/)

  .export(module)

# vim:ft=coffee ts=2 sw=2 et :

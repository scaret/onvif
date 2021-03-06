_linerase = (require '../lib/soapHelpers')._linerase
_cropName = (require '../lib/soapHelpers')._cropName
assert = require 'assert'
parseString = (require 'xml2js').parseString

describe 'Linerase function', () ->
  it 'should handle tag', (done) ->
    parseString '<a><b>text</b><c>text</c></a>', (err, result) ->
      assert.deepEqual _linerase(result), {
        a: {
          b: 'text'
          c: 'text'
        }
      }
      done()

  it 'should handle multiply tags', (done) ->
    parseString '<a><b>text</b><b>text</b></a>', (err, result) ->
      assert.deepEqual _linerase(result), {
        a: {
          b: [
            'text'
            'text'
          ]
        }
      }
      done()

  it 'should handle multiply tags deeply', (done) ->
    parseString '<a><b><c>text</c><d>t</d></b><b><c>text</c><d>t</d></b></a>', (err, result) ->
      assert.deepEqual _linerase(result), {
        a: {
          b: [
            {c: 'text', d: 't'}
            {c: 'text', d: 't'}
          ]
        }
      }
      done()

  it 'should deals with numbers', () ->
    assert.deepEqual _linerase({a: '34.23'}), {a: 34.23}
    assert.deepEqual _linerase({a: '34'}), {a: 34}
    assert.deepEqual _linerase({a: '0.34'}), {a: 0.34}
    assert.deepEqual _linerase({a: '00.34'}), {a: '00.34'}
    assert.deepEqual _linerase({a: '-0.34'}), {a: -0.34}
    assert.deepEqual _linerase({a: '-12'}), {a: -12}
    assert.deepEqual _linerase({a: '000'}), {a: '000'}
    assert.deepEqual _linerase({a: '012'}), {a: '012'}

  it 'should deals with datetime and not converts it to number', () ->
    assert.deepEqual _linerase({a: '2015-01-20T16:33:03Z'}), {a: '2015-01-20T16:33:03Z'}
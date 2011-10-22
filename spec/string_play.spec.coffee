sp = require 'src/string_play'

describe "string_play", ->
  it 'tokenizes a static string as one element', ->
    expect(sp.tokenize('llama is in the house').length).toEqual(1)

  it 'throws a token for {{}} variables', ->
    expect(JSON.stringify(sp.tokenize("it's almost {{hour}}"))).toEqual('["it\'s almost","{{hour}}"]')

  it 'doesn\'t tokenize  {{{}}} variables', ->
    expect(sp.tokenize('one {{{two}}} three').length).toEqual(1)

  it 'does process tokens in the middle', ->
    expect(sp.tokenize('one {{two}} three').length).toEqual(3)



describe 'match_static_or_same_token', ->
  it "matches the same variable replacement", ->
    expect(sp.match_static_or_same_token('{{a}}','{{a}}')).toEqual(true)

  it "doesn't match different variable replacements", ->
    expect(sp.match_static_or_same_token('{{a}}','{{b}}')).toEqual(false)

  it "doesn't match replacements to static strings", ->
    expect(sp.match_static_or_same_token('llama','{{llama}}')).toBe(false)

  it "doesn't match nulls", ->
    expect(sp.match_static_or_same_token(undefined,undefined)).toBe(false)

describe 'score_match', ->
  it "counts correctly", ->
    expect(sp.score_match([[1,2],[1,3]])).toEqual(1)

describe 'smooshed_templates', ->
  it 'smooshes templates', ->
  expect(sp.smooshed_template(["around {{hour}} o'clock","27 before {{foo}} the {{hour}}"]))
    .toEqual([ [ '27 before' ], [ '{{foo}}' ], [ 'around', 'the' ], [ '{{hour}}' ], [ 'o\'clock' ] ] )

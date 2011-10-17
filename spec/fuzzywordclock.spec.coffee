fwc = require 'src/fuzzywordclock'
describe "fuzzywordclock", ->
  it "Should tell me it's around midnight around midnight", =>
    midnight = new Date
    midnight.setHours(0)
    midnight.setMinutes(0)

    expect(fwc.fuzzy_time(midnight)).toEqual "around midnight"

fwc = require 'src/fuzzywordclock'
describe "fuzzywordclock", ->
  it "Should tell me it's around midnight around midnight", =>
    midnight = new Date
    midnight.setHours(0)
    midnight.setMinutes(0)

    expect(fwc.fuzzy_time(midnight)).toEqual "around midnight"

  it "should tell me what kind of day it is", ->
    a_monday = new Date # 2011-10-17 00:00:00
    a_monday.setHours(0)
    a_monday.setMinutes(0)
    a_monday.setDate(17)
    a_monday.setMonth(10)
    a_monday.setFullYear(2011)

    expect(fwc.fuzzy_datetime(a_monday)).toEqual("around midnight before a workday")

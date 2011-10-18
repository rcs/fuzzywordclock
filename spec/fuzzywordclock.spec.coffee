fwc = require 'src/fuzzywordclock'

describe "fuzzywordclock", ->
  it "Should tell me it's around midnight around midnight", =>
    midnight = new Date('2011-01-01 00:00:00')

    expect(fwc.fuzzy_time(midnight)).toEqual("around midnight")

  it "should tell me what kind of day it is, based on the time", ->
    a_monday = new Date('2011-10-17 12:00:00')
    expect(fwc.fuzzy_date(a_monday)).toEqual("on a workday")

  it "should tell me what kind of day it is, wrapping based on time", ->
    a_monday = new Date('2011-10-16 22:00:00')
    expect(fwc.fuzzy_date(a_monday)).toEqual( "before a workday")

  it "should tell me what kind of datetime it is", ->
    a_monday = new Date('2011-10-17 00:00:00')
    expect(fwc.fuzzy_datetime(a_monday)).toEqual("around midnight before a workday")

Milk = require 'Milk'

highest_element_not_past = (array, index) ->
  array[Object.keys(array).sort((a,b)->(a-b)).filter((x) -> x <= index).pop()]

# Why not an actual array, you ask? I didn't like the construction syntax.
time_templates = {
  0: "around {{hour.current}}", # around twelve
  5: "just past {{hour.current}}", # just past twelve 
  12: "quarter past {{hour.current}}", # quarter past twelve
      # TODO - there should be another string here
  22: "almost {{hour.current}} thirty", # almost twelve thirty
  28: "around {{hour.current}} thirty", # around twelve thirty
  36: "just past {{hour.current}} thirty", # just past twelve thirty
  41: "quarter to {{hour.next}}", # quarter to one
      # TODO - there should be another string here
  52: "almost {{hour.next}}", # almost one
  58: "around {{hour.next}}", # around one
}

# Given the minutes of the time, return the format string
time_expression = (date) ->
  # Find the highest valued template less than minutes
  highest_element_not_past(time_templates,date.getMinutes())

hour_strings = [
    "midnight", "one", "two", "three", "four", "five",
    "six", "seven", "eight", "nine", "ten", "eleven"
    "noon", "one", "two", "three", "four", "five",
    "six", "seven", "eight", "nine", "ten", "eleven"
  ]

human_hour = (date) -> 
  highest_element_not_past(hour_strings,date.getHours())

fuzzy_time = (date) ->
  format_string = time_expression(date)
  next_hour = new Date(date)
  next_hour.setHours(next_hour.getHours()+1)
  ctx = {
    hour: {
      current: human_hour(date),
      next: human_hour(next_hour)
    }
  }
  Milk.render(format_string, ctx)

prefix_strings = {
  0: 'before',
  6: 'on',
  20: 'before'
}


fuzzy_date = (date) -> 
  format_string = '{{date.prefix}} {{date.daytype}}'

  ctx = {
    date: {
      prefix: date_functions.prefix(date),
      daytype: date_functions.daytype(date)
    }
  }

  Milk.render(format_string,ctx)

daytype_strings = {
  0: 'a weekend day',
  1: 'a workday',
  6: 'the weekend'
}

date_functions = {}
date_functions['daytype'] = (date) ->
  working_date = new Date(date)

  if date.getHours() > 20
    working_date.setDate(working_date.getDate() + 1 )

  highest_element_not_past(daytype_strings,working_date.getDay())

date_functions['prefix'] = (date) ->
  highest_element_not_past(prefix_strings,date.getHours())


fuzzy_datetime = (date) ->
  fuzzy_time(date) + ' ' + fuzzy_date(date)

module.exports = {
  fuzzy_time: fuzzy_time,
  fuzzy_datetime: fuzzy_datetime,
  fuzzy_date: fuzzy_date
}

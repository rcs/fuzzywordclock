Milk = require 'Milk'

currentDate = new Date

minutes_past_hour = currentDate.getMinutes()


human_hour = (hour_number) -> 
  hours = [
      "midnight", "one", "two", "three", "four", "five",
      "six", "seven", "eight", "nine", "ten", "eleven"
      "noon", "one", "two", "three", "four", "five",
      "six", "seven", "eight", "nine", "ten", "eleven"
    ]
  hours[hour_number % hours.length]

# Given the minutes of the time, return the format string
time_expression = (minutes) ->
  # 0 - twelve, 1 - one
  if 0 <= minutes <= 4
    "around {{this_hour}}" # around twelve
  else if 5 <= minutes <= 11
    "just past {{this_hour}}" # just past twelve 
  else if 12 <= minutes <= 21
    "quarter past {{this_hour}}" # quarter past twelve
    # TODO - there should be another string here
  else if 22 <= minutes <= 27
    "almost {{this_hour}} thirty" # almost twelve thirty
  else if 28 <= minutes <= 35
    "around {{this_hour}} thirty" # around twelve thirty
  else if 36 <= minutes <= 40
    "just past {{this_hour}} thirty"
  else if 41 <= minutes <= 51
    "quarter to {{next_hour}}" # quarter to one
    # TODO - there should be another string here
  else if 52 <= minutes <= 57
    "almost {{next_hour}}" # almost one
  else
    "around {{next_hour}}" # around one

fuzzy_time = (date) ->
  format_string = time_expression(date.getMinutes())
  ctx = {
    this_hour: human_hour(currentDate.getHours()),
    next_hour: human_hour(currentDate.getHours()+1)
  }
  Milk.render(format_string, ctx)

process.stdout.write fuzzy_time(new Date) + '\n'

module.exports.fuzzy_time = fuzzy_time

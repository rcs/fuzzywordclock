Milk = require 'Milk'

currentDate = new Date

minutes_past_hour = currentDate.getMinutes()

hours = [
    "midnight",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven"
    "noon",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven"
  ] 

this_hour = hours[currentDate.getHours() % hours.length]
next_hour = hours[(currentDate.getHours() + 1) % hours.length]

# Given the minutes of the time, return the format string
minute_expression = (minutes) ->
  # 0 - twelve, 1 - one
  if 0 <= minutes <= 4
    "about {{this_hour}}" # about twelve
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
    "about {{next_hour}}" # about one


format_string = minute_expression(currentDate.getMinutes()) + '\n'


process.stdout.write minute_expression(currentDate.getMinutes()) + '\n'

ctx = {
  this_hour: this_hour,
  next_hour: next_hour
}

process.stdout.write Milk.render(format_string, ctx) + '\n'


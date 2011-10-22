must_var_re =  new RegExp('^{{[^{]+}}$')
tokenize = (str) ->
  split = ' '
  tokens = []
  token_stream = str.split(split)

  tokens[0] = token_stream.shift()

  last_was_var = tokens[0].match(must_var_re)
  for token in token_stream
    if token.match(must_var_re)
      tokens.push(token)
      last_was_var = true
    else
      if last_was_var
        tokens.push(token)
      else
        tokens.push(tokens.pop() + split + token)
      last_was_var = false

  tokens

match_static_or_same_token = (a,b) ->
  if a?
    if a.toString().match(must_var_re)
      if a == b
        true
      else
        false
    else
      false
  else
    if b?
      if b.toString().match(must_var_re)
        false
      else
        true
    else
      false

token_match_possible = (list) -> 
  first = list[0]
  others = list.slice(1)

  possible = true
  for i in [0..first.length-1]
    for other in others
      if i.toString().match(must_var_re)
        if others[i] != first[i]
          possible = false

  possible

score_match = (expanded, match_func = (a,b)-> a == b )->
  length = expanded[0].length

  score = 0
  for i in [0..length-1]
    matched = true
    test_val = expanded[0][i]
    for other in expanded.slice(1)
      unless match_func(test_val,other[i])
        matched = false

    score = score + 1 if matched

  score


slide_arrays = (a,b) ->
  arrays = []
  for offset in [(-1*(a.length) ) .. (b.length)]
    arrays.push(offset_arrays(a,b,offset))

  arrays

offset_arrays = (a,b,offset) ->
  [
    (if offset > 0 then [0..offset-1].map(->undefined) else [])
      .concat(a)
      .concat(if a.length+offset < b.length then [a.length+offset .. b.length-1].map(->undefined) else []),
    (if offset < 0 then [offset+1 .. 0].map(->undefined) else [])
      .concat(b)
      .concat(if offset+a.length > b.length then [ b.length+1 .. offset+a.length].map(->undefined) else [] )
  ]

windowed_arrays = (a,window_size) ->
  return [a] if window_size <= a.length
  [0..window_size-a.length].map((offset)->
    (if offset > 0 then [0..offset-1].map(->undefined) else [])
      .concat(a)
      .concat(if offset + a.length < window_size then [offset+a.length .. window_size-1].map(->undefined) else [])
  )

combinations = (arrays) ->
  first = arrays[0]
  return first.map((a)->[a]) if arrays.length ==  1
  arrays = arrays.slice(1)

  res = []
  for combination in combinations(arrays)
    for these in first
      res.push([these].concat(combination))
      #res.push(if combination.hasOwnProperty('length') then [these].concat(combination) else [these,combination])
  res

all_combinations = (templates) ->
  max_length = templates.reduce( ((sum,arr) -> sum+arr.length) ,0)
  combinations(windowed_arrays(a,max_length) for a in templates)

best_matching_all_combinations = (templates) ->
  matches = []
  all_combos = all_combinations(templates).filter(token_match_possible)

  for i in [0..all_combos.length-1]
    score = score_match(all_combos[i],match_static_or_same_token)
    if matches[score]?
      matches[score] = matches[score].concat(i)
    else
      matches[score] = [i]

  # TODO: use truncated length (trim nulls from both sides) to figure which to return
  return all_combos[matches[matches.length-1][0]]

smoosh_arrays = (possibilities) ->
  final = []

  for possibility in possibilities
    for i in [0..possibility.length-1]
      if possibility[i]?
        if final[i]?
          if final[i].indexOf(possibility[i]) == -1
            final[i] = final[i].concat(possibility[i])
        else
          final[i] = [possibility[i]]

  final

smooshed_template = (templates) ->
  smoosh_arrays(best_matching_all_combinations(templates.map((a)->tokenize(a))))




module.exports = {
  tokenize: tokenize,
  slide_arrays: slide_arrays,
  offset_arrays: offset_arrays,
  windowed_arrays: windowed_arrays,
  all_combinations: all_combinations,
  combinations: combinations,
  match_static_or_same_token: match_static_or_same_token,
  score_match: score_match,
  best_matching_all_combinations: best_matching_all_combinations,
  token_match_possible: token_match_possible,
  smoosh_arrays: smoosh_arrays
  smooshed_template: smooshed_template
}

module.exports = (bacronym, acronym) ->
  acronym == bacronym.split ' '
    .map (token)-> token.charAt 0
    .join ''
    .toUpperCase()

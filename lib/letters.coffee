_ = require 'lodash'

# http://en.wikipedia.org/wiki/Letter_frequency#Relative_frequencies_of_the_first_letters_of_a_word_in_the_English_language
rawDistribution =
  t:	0.16671
  a:	0.11602
  s:	0.07755
  h:	0.07232
  w:	0.06753
  i:	0.06286
  o:	0.06264
  b:	0.04702
  m:	0.04374
  f:	0.03779
  c:	0.03511
  l:	0.02705
  d:	0.02670
  p:	0.02545
  n:	0.02365
  e:	0.02007
  g:	0.01950
  r:	0.01653
  y:	0.01620
  u:	0.01487
  v:	0.00649
  j:	0.00597
  k:	0.00590
  q:	0.00173
  x:	0.00037
  z:	0.00034


# Roughly modeled on the raw frequency 
adjDistribution =
  t: 150
  a: 150

  s: 100
  h: 100
  w: 100
  i: 100
  o: 100

  b: 80
  m: 80
  f: 80
  c: 80

  l: 60
  d: 60
  p: 60
  n: 60

  e: 40
  g: 40
  r: 40
  y: 40
  u: 40

  v: 20
  j: 20
  k: 20

  q: 10
  x: 10
  z: 10


add = (prev, sum)-> prev + sum

randomLetter = ()->
  sumLetters = _.reduce(adjDistribution, add, 0)
  r = _.random 0, sumLetters
  cumSum = 0
  for own letter, freq of adjDistribution
    cumSum += freq
    if r < cumSum
      return letter
  # If all else fails, give 'em a 't'
  't'

randomLetters = (num=1)->
  ret = []
  while num--
    ret.push randomLetter()
  ret



module.exports = {randomLetter, randomLetters}

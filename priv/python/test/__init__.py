import random
import fortune

def example():
  return random.random()

# Remember that the return value will be a unicode UTF-8
def myfortune():
  f = fortune.get_random_fortune('/Users/henrikgudbrandpetersen/work/fortunes/fortunes')
  print(f)
  return f

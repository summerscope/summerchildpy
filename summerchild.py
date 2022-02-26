# Bash quiz of Sweet Summer Child Score 

from cgitb import lookup
import json
import collections
from wsgiref import validate
io = open("questions.json", "r")

data = json.load(io)
# print (data[0])

State = collections.namedtuple('State', ['multiplier', 'score', 'currentq', 'recommendations'])

start_state = State(multiplier = 1, score = 0, currentq = "Q1", recommendations = [])

def print_question(text, answers, answer_set, score):
  print(text)
  print(answers)
  x = input()
  if x.upper() in answer_set:
    print('You selected ' + x)
    return x 
  else:
    print('Sorry '+ x +' is not a valid answer, please try again')
    return None

def validate_answer(text, answers, answer_set, score):
  """The purpose of this function is to keep asking the question until we get a valid answer"""
  answered = None
  while not answered:
    answered = print_question(text, answers, answer_set, score)
  return answered

def format_question(question):
  text = question["text"]
  answers = question["answers"]
  answer_list = []
  for key,value in answers.items():
    answer_list.append(key + ') ' + value["text"])
  answers_joined = "\n".join(answer_list)
  # print (answers_joined)
  # print (text)
  answer_key = validate_answer(text, answers_joined, answers.keys(), 0)
  return answers[answer_key]

def update_state(state, answer):
  new_state = state._replace(
    multiplier = answer.get("multiplier", state.multiplier),
    score = state.score + answer.get("score", 0),
    currentq = answer["nextq"],
    recommendations = state.recommendations +  [answer["recommendation"]] 
  )
  return new_state

def ask_question(question, state):
  answer = format_question(question)
  new_state = update_state(state, answer)
  return new_state

# format_question(data[1])

print(start_state)
next_state = ask_question(data[1], start_state)
print(next_state)



# validate_answer('How large is the target cohort for your decision system? \nThe people your system makes decisions, predictions or classifications about.', 'A. 1-100 \nB. 101-1,000 \nC. 1,001 - 10,000', ['A', 'B', 'C'], 0)
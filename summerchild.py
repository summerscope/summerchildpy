# Bash quiz of Sweet Summer Child Score 

from cgitb import lookup
import json
import collections
from typing import final
from wsgiref import validate
io = open("questions.json", "r")

data = json.load(io)
# print (data[0])

State = collections.namedtuple('State', ['multiplier', 'score', 'currentq', 'recommendations'])

start_state = State(multiplier = 1, score = 0, currentq = "Q1", recommendations = [])

def print_question(text, answers, answer_set):
  print(f"\n{text}")
  print(answers)
  x = input()
  uppercase_input = x.upper()
  for answer in answer_set:
    if answer.upper() == uppercase_input:
      # print('You selected ' + x)
      return answer
  # This is what happens if input is invalid
  print(f"\n⚠️  Sorry {x} is not a valid answer, please try again  ⚠️")
  return None

def validate_answer(text, answers, answer_set):
  """The purpose of this function is to keep asking the question until we get a valid answer"""
  answered = None
  while not answered:
    answered = print_question(text, answers, answer_set)
  return answered

def format_question(question):
  text = question["text"]
  answers = question["answers"]
  answer_list = []
  for key,value in answers.items():
    answer_text = value["text"]
    answer_list.append(f"{key}) {answer_text}")
  answers_joined = "\n".join(answer_list)
  # print (answers_joined)
  # print (text)
  answer_key = validate_answer(text, answers_joined, answers.keys())
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

def lookup_question(data, id):
  for question in data: 
    if question["id"] == id:
      return question
  raise KeyError(f"{id} was not found")

def parse_range(range_str):
  s1, s2 = range_str.split("-")
  x1 = int(s1)
  x2 = int(s2)
  return x1, x2

def print_summary(data, state):
  # print(state)
  final_score = (state.multiplier * state.score)
  print(f"Your final score is {state.score} and your multiplier is {state.multiplier}")
  print(f"Your sweet summer child score is {final_score}")
  results_all = lookup_question(data, "Results")
  for k,range_obj in results_all["results"].items():
    range = range_obj["range"]
    title = range_obj["title"]
    text = range_obj["text"]
    low, high = parse_range(range)
    if final_score >= low and final_score <= high:
      print(f"{range}\n{title}\n{text}")
  print("Recommendations for improving your score:")
  for rec in state.recommendations:
    if rec != "":
      print(f"• {rec}")
  if len(state.recommendations) == 0:
    print("No recommendations to improve your score.")

def run_quiz(data, state):
  while state.currentq and state.currentq != "":
    question = lookup_question(data, state.currentq)
    state = ask_question(question, state)
  print_summary(data, state)


run_quiz(data, start_state)

# run_quiz(data, start_state._replace(currentq = "Q24"))
# print(start_state)
# format_question(data[1])
# next_state = ask_question(data[0], start_state)
# print(next_state)
# validate_answer('How large is the target cohort for your decision system? \nThe people your system makes decisions, predictions or classifications about.', 'A. 1-100 \nB. 101-1,000 \nC. 1,001 - 10,000', ['A', 'B', 'C'], 0)
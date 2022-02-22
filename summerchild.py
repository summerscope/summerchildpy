# Bash quiz of Sweet Summer Child Score 

import json
from wsgiref import validate
io = open("questions.json", "r")

data = json.load(io)

# print (data[0])

def ask_question(text, answers, answer_set, score):
  print(text)
  print(answers)
  x = input()
  if x.upper() in answer_set:
    print('You selected ' + x)
    return True 
  else:
    print('Sorry '+ x +' is not a valid answer, please try again')
    return False

def validate_answer(text, answers, answer_set, score):
  answered = False
  while not answered:
    answered = ask_question(text, answers, answer_set, score)

def format_question(question):
  text = question["text"]
  answers = question["answers"]
  answer_list = []
  for key,value in answers.items():
    answer_list.append(key + ') ' + value["text"])
  answers_joined = "\n".join(answer_list)
  # print (answers_joined)
  # print (text)
  validate_answer(text, answers_joined, answers.keys(), 0)

format_question(data[1])


# validate_answer('How large is the target cohort for your decision system? \nThe people your system makes decisions, predictions or classifications about.', 'A. 1-100 \nB. 101-1,000 \nC. 1,001 - 10,000', ['A', 'B', 'C'], 0)
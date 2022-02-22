import json
from wsgiref import validate
io = open("questions.json", "r")

data = json.load(io)

qs = pd.json_normalize("questions.json",  'A')
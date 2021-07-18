# -*- coding: utf-8 -*-
"""encadenament_endavant.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1yWWxJ3I9bR0id-u-YUP3ANyaO_R1TuTd
"""

BD = ['P', 'J', 'noC']
target = 'K'
rules_used = []
target_found = False
no_rules_to_be_used = False
num_rules = 4

def rules(id_rule, BD):
    if id_rule == 1:
      if 'noS' in BD:
        return True, 'V'
      else:
        return False, ''
    elif id_rule == 2:
      if 'S' in BD and 'I' in BD:
        return True, 'K'
      else:
        return False, ''
    elif id_rule == 3:
      if 'noC'  in BD:
        return True, 'S'
      else:
        return False, ''
    elif id_rule == 4:
      if 'P' in BD and 'J' in BD:
        return True, 'I'
      else:
        return False, ''


def select_rule(valid_rules):
  return valid_rules[0]
  
while not target_found and not no_rules_to_be_used:
  valid_rules = []
  for ii in range(1, num_rules + 1):
    valid_rule, new_state = rules(ii,BD)
    if valid_rule and ii not in rules_used and new_state not in BD:
      valid_rules.append(ii)
  if len(valid_rules) > 0:
    selected_rule = select_rule(valid_rules)
    rules_used.append(selected_rule)
    valid_rule, new_state = rules(selected_rule,BD)
    BD.append(new_state)
    print("selected_rule: " + str(selected_rule))
    print("BD: ")
    print(BD)
    if target in BD:
      target_found = True
      print("Target found!")
  else:
    no_rules_to_be_used = True
    print("Target not found and no rules can be used")

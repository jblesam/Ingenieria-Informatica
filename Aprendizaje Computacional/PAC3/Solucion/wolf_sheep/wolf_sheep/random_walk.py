'''
Generalized behavior for random walking, one grid cell at a time.
'''

import random

from mesa import Agent


class RandomWalker(Agent):
    '''
    Class implementing random walker methods in a generalized manner.

    Not indended to be used on its own, but to inherit its methods to multiple
    other agents.

    '''
    age = 0
    grid = None
    x = None
    y = None
    moore = True
    ageMax = 20

    def __init__(self, pos, model, moore=True, age = 0, ageMax = 0):
        '''
        grid: The MultiGrid object in which the agent lives.
        x: The agent's current x coordinate
        y: The agent's current y coordinate
        moore: If True, may move in all 8 directions.
                Otherwise, only up, down, left, right.
        '''
        super().__init__(pos, model)
        self.pos = pos
        self.moore = moore
        self.age = age
        self.ageMax = ageMax
        
        
        ''' Solution PEC 3 IA 2 UOC 
        '''
    def step(self):
        self.age = float(self.age) + float(1.0/12.0) 

    def random_move(self):
        '''
        Step one cell in any allowable direction.
        '''
        # Pick the next cell from the adjacent cells.
        next_moves = self.model.grid.get_neighborhood(self.pos, self.moore, True)
        next_move = random.choice(next_moves)
        # Now move:
        self.model.grid.move_agent(self, next_move)


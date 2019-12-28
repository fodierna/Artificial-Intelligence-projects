# Artificial-Intelligence-projects
Four projects made for the Artificial Intelligence course taught in the MSc in Computer Science of the University of Turin.

## Project 1: Prolog maze [Prolog-poject]
Different search algorithms have been implemented in order to find the path to the exit in a maze. 

The algorithms implemented are:
- Iterative Deepening Search (IDS)
- Iterative Deepening A* (ID A*)
- A* 

For the informed search algorithms two heuristics have been implemented: 
- Manhattan distance
- Diagonal distance

A total of 113 tests were performed. We used mazes of different sizes with different number of obstacles. The best search algorithm is A* with Manhattan distance heuristic, which is able to solve 1000 x 1000 mazes with the 30% of obstacles in only 180 seconds using only 10MB of memory.

## Project 2: Class Schedule [ASP-programming]
The goal of the project is to formulate a weekly class schedule given teachers, subjects, classroom and hours. We formulated different constraints in order to achieve the goal.  

## Project 3: Expert systems [CLIPS-project]
The goal is to realize an expert system to be used in a travel agency to propose a vacation package based on the user preferences. 
The user can choose the number of nights and people, the budget, zero or more locations, zero or more kind of tourism, the minimum number of stars of the hotels. The system, based on the preferences of the user and the budget returns the top-5 vacation packages ranked using a confidence measure. The expert system is implemented in CLIPS.

## Project 4: Kalman Filter [Kalman-Filter]
A Python implementation of the Kalman Filter. The simulated process if the uniformly accelerated motion in 2D. Different expirements were carried out, in different condition of noise both on process and measurement.

For all the project you can find a report (relazione.pdf). At the moment the reports are available only in Italian.

# Authors:
- Francesco Odierna
- Alessio Ballone


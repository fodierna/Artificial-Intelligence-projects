from random import randint
import sys

size = ((int)(sys.argv[1]),(int)(sys.argv[2]))

maze = [['x' if (randint(0,3) > 1)  else '_'  for y in range(size[1]) ] for x in range(size[0])]
maze[0][0], maze[size[0]-1][size[1]-1] = 'x','x'

with open('python_out.pl', 'w') as maze_file:

    maze_file.write('num_righe('+str(size[0])+').\n')
    maze_file.write('num_colonne('+str(size[1])+').\n\n')
     
    maze_file.write('iniziale(pos(1,1)).\n')
    maze_file.write('finale(pos('+str(size[0])+','+str(size[1])+')).\n\n\n')

    toStr = []
    
    for i in range(size[0]):
        toStr += ['|']
        for j in range(size[1]):
            if maze[i][j] == '_' :
                maze_file.write('occupata(pos('+str(i+1)+','+str(j+1)+')).\n')
                toStr += ['▩ ']
            else : toStr += ['  ']
        toStr += ['|'+str(i+1)+'\n']

toStr[1] = 'xx'
toStr[-2] = 'xx'
print(''.join(toStr))
line='|'
for i in range(size[1]):
	if((i+1)%2==1):
		line+=str(i+1)
		if((i+1)<10):
			line+=' '
	else:
		line+='  '
		
print(line)



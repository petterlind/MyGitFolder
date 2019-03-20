import os

cwd = os.getcwd()


vec = [r'\Job-1.lck', r'\Job-1.com', r'\Job-1.dat', r'\Job-1.log', r'\Job-1.msg', r'\Job-1.odb', r'\Job-1.prt', r'\Job-1.sim', r'\Job-1.sta']

for pos in vec:
    try:
        os.remove(cwd + pos)
    except:
        print('Could not remove file:' + pos)

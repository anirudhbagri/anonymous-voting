def returnVotes():
    return {"yes_count": yes_count, "no_count": no_count}

def printVotes():
  print('Yes: ' + str(yes_count) + ' : ' + 'No: ' + str(no_count))

from flask import Flask
from flask import jsonify
app = Flask(__name__) 
  
@app.route('/ping') 
def hello_world(): 
    return 'Pong'
	
@app.route('/votes') 
def get_votes():
    printVotes()
    return jsonify(returnVotes())

@app.route('/updateyes') 
def update_yes(): 
    printVotes()
    global yes_count
    yes_count += 1
    return 'Ok'
	
@app.route('/updateno')
def update_no():
    printVotes() 
    global no_count
    no_count += 1
    return 'Ok'
	
@app.route('/reset') 
def reset():
    global yes_count
    yes_count = 0
    global no_count
    no_count = 0
    printVotes()
    return 'Ok'

yes_count = 0
no_count = 0	

# main driver function 
if __name__ == '__main__': 
  app.run(host='0.0.0.0', port=80)

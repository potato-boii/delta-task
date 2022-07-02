from flask import Flask,render_template
import re
import pwd

app=Flask(__name__)

@app.route('/')
def display():
	passwd_content=pwd.getpwall()
	managerstrings=re.findall(r"MANAGER\d",str(passwd_content))
	stringout=" "
	managerlist=list(set(managerstrings))
	for managerstring in managerlist:
		stringout+=managerstring
		path="/home/"+managerstring+"/summary.txt"
		file_summary=open(path,'r')
		file_content=file_summary.read()
		file_summary.close()
		stringout+=file_content
	return render_template("index.html",content=stringout)
	
@app.route("/<variable>")
def dynamic_url(variable):
	stringout=" "
	stringout+=variable
	path="/home/"+variable+"/summary.txt"
	file_summary=open(path,'r')
	file_content=file_summary.read()
	file_summary.close()
	stringout+=file_content
	return render_template("index.html",content=stringout)
	
if __name__ == '__main__' :
	app.run(host='0.0.0.0',port=5000)


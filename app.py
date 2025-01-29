from flask import Flask, request

app = Flask(__name__)

@app.route('/read_file', methods=['GET'])
def read_file():
    filename = request.args.get('filename')
    if filename:
        with open(f"files/{filename}", 'r') as file:
            content = file.read()
        return content
    return "No filename provided"

if __name__ == '__main__':
    app.run(debug=True)
    
    
@app.route('/ping', methods=['GET'])
def ping():
    ip = request.args.get('ip')
    if ip:
        response = os.system(f"ping -c 1 {ip}")
        return f"Ping response: {response}"
    return "No IP provided"

if __name__ == '__main__':
    app.run(debug=True)
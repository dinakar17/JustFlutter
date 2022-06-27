from flask import Flask, request, jsonify
import werkzeug
from main import predict

app = Flask(__name__)



@app.route("/", methods=["POST", "GET"])
def hello_world():
    if request.method == "POST":
        imageFile = request.files['image']
        filename = werkzeug.utils.secure_filename(imageFile.filename)
        # imageFile.save("./images/" + filename)
        results = predict(imageFile)
        # res.body = results
        print(results)
        return jsonify(results)
    else:
        print("GET request received")
        return 'get request response'

    
    
    

if __name__ == "__main__":
    app.run(debug=True)

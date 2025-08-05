from flask import Flask, request, jsonify
import subprocess
import shlex

app = Flask(__name__)

@app.route('/eval', methods=['GET', 'POST'])
def evaluate():
    # Récupérer l'expression depuis les paramètres GET ou POST
    expr = request.args.get('expr') or (request.json and request.json.get('expr'))
    
    if not expr:
        return jsonify({"error": "Le paramètre 'expr' est requis"}), 400
    
    try:
        # Sécuriser l'entrée et exécuter Marina
        safe_expr = shlex.quote(expr)
        cmd = f"./marina {safe_expr}"
        result = subprocess.run(
            cmd, 
            shell=True, 
            cwd='/app/marina',
            capture_output=True, 
            text=True
        )
        
        if result.returncode == 0:
            return jsonify({"result": result.stdout.strip()})
        else:
            return jsonify({"error": result.stderr.strip()}), 400
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

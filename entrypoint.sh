#!/bin/sh

# Démarrer le serveur API avec Gunicorn (production)
cd /app/api
gunicorn --bind 0.0.0.0:8080 app:app

# Pour le développement, vous pourriez utiliser à la place:
# python app.py

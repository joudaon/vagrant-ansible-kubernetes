from flask import Flask, session, redirect, url_for, request
from markupsafe import escape
import os;

app = Flask(__name__)

# Configure environment variables
app.config['POD_NAME'] = os.environ.get('POD_NAME') if os.environ.get('POD_NAME') else 'POD_NAME'
app.config['POD_NAMESPACE'] = os.environ.get('POD_NAMESPACE') if os.environ.get('POD_NAMESPACE') else 'POD_NAMESPACE'
app.config['POD_IP'] = os.environ.get('POD_IP') if os.environ.get('POD_IP') else 'POD_IP'
app.config['NODE_NAME'] = os.environ.get('NODE_NAME') if os.environ.get('NODE_NAME') else 'NODE_NAME'
app.config['SERVICE_ACCOUNT'] = os.environ.get('SERVICE_ACCOUNT') if os.environ.get('SERVICE_ACCOUNT') else 'SERVICE_ACCOUNT'


@app.route('/')
def index():
    return '<p> POD_NAME: ' + app.config['POD_NAME'] + '</p>' \
          '<p> POD_NAMESPACE: ' + app.config['POD_NAMESPACE'] + '</p>' \
          '<p> POD_IP: ' + app.config['POD_IP'] + '</p>' \
          '<p> NODE_NAME: ' + app.config['NODE_NAME'] + '</p>' \
          '<p> SERVICE_ACCOUNT: ' + app.config['SERVICE_ACCOUNT'] + '</p>'

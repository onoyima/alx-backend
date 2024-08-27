#!/usr/bin/env python3
from flask import Flask, render_template, request, g
from flask_babel import Babel, _
from pytz import timezone
import pytz.exceptions

class Config:
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"

app = Flask(__name__)
app.config.from_object(Config)
babel = Babel(app)

users = {
    1: {"name": "Balou", "locale": "fr", "timezone": "Europe/Paris"},
    2: {"name": "Beyonce", "locale": "en", "timezone": "US/Central"},
    3: {"name": "Spock", "locale": "kg", "timezone": "Vulcan"},
    4: {"name": "Teletubby", "locale": None, "timezone": "Europe/London"},
}

def get_user():
    try:
        user_id = int(request.args.get('login_as'))
        return users.get(user_id)
    except (TypeError, ValueError):
        return None

@app.before_request
def before_request():
    g.user = get_user()

@babel.localeselector
def get_locale():
    if g.user:
        locale = g.user.get('locale')
        if locale in app.config['LANGUAGES']:
            return locale
    return request.accept_languages.best_match(app.config['LANGUAGES'])

@babel.timezoneselector
def get_timezone():
    if g.user and g.user['timezone']:
        try:
            return timezone(g.user['timezone'])
        except pytz.exceptions.UnknownTimeZoneError:
            pass
    return app.config['BABEL_DEFAULT_TIMEZONE']

@app.route('/')
def index():
    user_message = _("not_logged_in")
    if g.user:
        user_message = _("logged_in_as", username=g.user['name'])
    return render_template('7-index.html', title=_("home_title"), header=_("home_header"), user_message=user_message)

if __name__ == "__main__":
    app.run()


#!/bin/bash

# Create directories
mkdir -p templates translations/en/LC_MESSAGES translations/fr/LC_MESSAGES

# Create README.md
cat <<EOL > README.md
# i18n Flask App Setup

This project demonstrates the setup of an internationalized Flask web application.
It includes basic routing, Babel setup, and language translation using gettext.

## Requirements
- Python 3.7
- Flask
- Flask-Babel

## Setup
1. Install the required packages:
   \`\`\`bash
   pip3 install flask flask_babel
   \`\`\`
2. Run the Flask app:
   \`\`\`bash
   python3 0-app.py
   \`\`\`

## Tasks Overview
1. Basic Flask app (0-app.py)
2. Basic Babel setup (1-app.py)
3. Get locale from request (2-app.py)
4. Parametrize templates (3-app.py)
5. Force locale with URL parameter (4-app.py)
6. Mock logging in (5-app.py)
7. Use user locale (6-app.py)
8. Infer appropriate time zone (7-app.py)
9. Display the current time (8-app.py)

EOL

# Create the basic Flask app file (0-app.py)
cat <<EOL > 0-app.py
#!/usr/bin/env python3
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('0-index.html')

if __name__ == "__main__":
    app.run()

EOL

# Create the basic template (0-index.html)
cat <<EOL > templates/0-index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Holberton</title>
</head>
<body>
    <h1>Hello world</h1>
</body>
</html>
EOL

# Create Babel setup (1-app.py)
cat <<EOL > 1-app.py
#!/usr/bin/env python3
from flask import Flask, render_template
from flask_babel import Babel

class Config:
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"

app = Flask(__name__)
app.config.from_object(Config)
babel = Babel(app)

@app.route('/')
def index():
    return render_template('1-index.html')

if __name__ == "__main__":
    app.run()

EOL

# Create the template for 1-app.py (1-index.html)
cp templates/0-index.html templates/1-index.html

# Create locale selector (2-app.py)
cat <<EOL > 2-app.py
#!/usr/bin/env python3
from flask import Flask, render_template, request
from flask_babel import Babel

class Config:
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"

app = Flask(__name__)
app.config.from_object(Config)
babel = Babel(app)

@babel.localeselector
def get_locale():
    return request.accept_languages.best_match(app.config['LANGUAGES'])

@app.route('/')
def index():
    return render_template('2-index.html')

if __name__ == "__main__":
    app.run()

EOL

# Create the template for 2-app.py (2-index.html)
cp templates/0-index.html templates/2-index.html

# Create babel.cfg
cat <<EOL > babel.cfg
[python: **.py]
[jinja2: **/templates/**.html]
extensions=jinja2.ext.i18n
EOL

# Create the app for template parametrization (3-app.py)
cat <<EOL > 3-app.py
#!/usr/bin/env python3
from flask import Flask, render_template, request
from flask_babel import Babel, _

class Config:
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"

app = Flask(__name__)
app.config.from_object(Config)
babel = Babel(app)

@babel.localeselector
def get_locale():
    return request.accept_languages.best_match(app.config['LANGUAGES'])

@app.route('/')
def index():
    return render_template('3-index.html', title=_("home_title"), header=_("home_header"))

if __name__ == "__main__":
    app.run()

EOL

# Create the template for 3-app.py (3-index.html)
cat <<EOL > templates/3-index.html
<!DOCTYPE html>
<html lang="{{ get_locale() }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
</head>
<body>
    <h1>{{ header }}</h1>
</body>
</html>
EOL

# Initialize Babel translations
pybabel extract -F babel.cfg -o messages.pot .
pybabel init -i messages.pot -d translations -l en
pybabel init -i messages.pot -d translations -l fr

# Populate translations
cat <<EOL > translations/en/LC_MESSAGES/messages.po
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\\n"
"Language: en\\n"

msgid "home_title"
msgstr "Welcome to Holberton"

msgid "home_header"
msgstr "Hello world!"
EOL

cat <<EOL > translations/fr/LC_MESSAGES/messages.po
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\\n"
"Language: fr\\n"

msgid "home_title"
msgstr "Bienvenue chez Holberton"

msgid "home_header"
msgstr "Bonjour monde!"
EOL

# Compile translations
pybabel compile -d translations

# Create locale parameter app (4-app.py)
cat <<EOL > 4-app.py
#!/usr/bin/env python3
from flask import Flask, render_template, request
from flask_babel import Babel, _

class Config:
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"

app = Flask(__name__)
app.config.from_object(Config)
babel = Babel(app)

@babel.localeselector
def get_locale():
    locale = request.args.get('locale')
    if locale and locale in app.config['LANGUAGES']:
        return locale
    return request.accept_languages.best_match(app.config['LANGUAGES'])

@app.route('/')
def index():
    return render_template('4-index.html', title=_("home_title"), header=_("home_header"))

if __name__ == "__main__":
    app.run()

EOL

# Create the template for 4-app.py (4-index.html)
cp templates/3-index.html templates/4-index.html

# Create user mock login (5-app.py)
cat <<EOL > 5-app.py
#!/usr/bin/env python3
from flask import Flask, render_template, request, g
from flask_babel import Babel, _

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

@app.route('/')
def index():
    user_message = _("not_logged_in")
    if g.user:
        user_message = _("logged_in_as", username=g.user['name'])
    return render_template('5-index.html', title=_("home_title"), header=_("home_header"), user_message=user_message)

if __name__ == "__main__":
    app.run()

EOL

# Create the template for 5-app.py (5-index.html)
cat <<EOL > templates/5-index.html
<!DOCTYPE html>
<html lang="{{ get_locale() }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
</head>
<body>
    <h1>{{ header }}</h1>
    <p>{{ user_message }}</p>
</body>
</html>
EOL

# Create use user locale (6-app.py)
cp 5-app.py 6-app.py
cp templates/5-index.html templates/6-index.html

# Infer timezone (7-app.py)
cat <<EOL > 7-app.py
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

EOL

# Create the template for 7-app.py (7-index.html)
cp templates/5-index.html templates/7-index.html

# Create display current time (8-app.py)
cat <<EOL > 8-app.py
#!/usr/bin/env python3
from flask import Flask, render_template, request, g
from flask_babel import Babel, _
from datetime import datetime
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
    current_time = datetime.now(timezone(get_timezone())).strftime('%Y-%m-%d %H:%M:%S')
    return render_template('8-index.html', title=_("home_title"), header=_("home_header"), user_message=user_message, current_time=current_time)

if __name__ == "__main__":
    app.run()

EOL

# Create the template for 8-app.py (8-index.html)
cat <<EOL > templates/8-index.html
<!DOCTYPE html>
<html lang="{{ get_locale() }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
</head>
<body>
    <h1>{{ header }}</h1>
    <p>{{ user_message }}</p>
    <p>{{ current_time }}</p>
</body>
</html>
EOL

echo "Setup complete. Run the Flask app using: python3 0-app.py or any other task file."


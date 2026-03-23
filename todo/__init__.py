import os
from flask import Flask
from todo.models import db

def create_app(config_overrides=None):
    app = Flask(__name__)

    # 1. Check for an environment variable first (from Docker Compose)
    # 2. Fall back to SQLite if nothing is found (for local testing)
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get(
        "SQLALCHEMY_DATABASE_URI", "sqlite:///db.sqlite"
    )

    if config_overrides:
        app.config.update(config_overrides)

    # Load models and create tables
    from todo.models import db
    from todo.models.todo import Todo
    db.init_app(app)

    with app.app_context():
        db.create_all()
        db.session.commit()

    from todo.views.routes import api
    app.register_blueprint(api)

    return app
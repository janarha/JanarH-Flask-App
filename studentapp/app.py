import os
import psycopg2
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST", "db")
DB_PORT = os.environ.get("DB_PORT", "5432")
DB_NAME = os.environ.get("DB_NAME", "appdb")
DB_USER = os.environ.get("DB_USER", "appuser")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "apppassword")


def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )
    return conn


def init_db():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS messages (
            id SERIAL PRIMARY KEY,
            content TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        )
    """
    )
    conn.commit()
    cur.close()
    conn.close()


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        content = request.form.get("message", "").strip()
        if content:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("INSERT INTO messages (content) VALUES (%s)", (content,))
            conn.commit()
            cur.close()
            conn.close()
        return redirect(url_for("index"))

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT content, created_at FROM messages ORDER BY created_at DESC")
    messages = cur.fetchall()
    cur.close()
    conn.close()
    return render_template("index.html", messages=messages)


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)

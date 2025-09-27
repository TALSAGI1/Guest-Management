from flask import Blueprint, render_template, request, redirect, url_for
from . import db
from .models import Guest

bp = Blueprint("main", __name__)

@bp.route("/")
def index():
    guests = Guest.query.order_by(Guest.created_at.desc()).all()
    return render_template("index.html", guests=guests)

@bp.route("/guests/new", methods=["GET","POST"])
def guest_new():
    if request.method == "POST":
        g = Guest(name=request.form["name"], email=request.form["email"])
        db.session.add(g); db.session.commit()
        return redirect(url_for("main.index"))
    return render_template("guest_form.html")
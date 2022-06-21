#!/usr/bin/python3
from unicodedata import category
from wsgiref.handlers import CGIHandler
from flask import Flask, redirect
from flask import render_template, request
import psycopg2
import psycopg2.extras

# SGBD configs
DB_HOST="db"
DB_USER="postgres"
DB_DATABASE=DB_USER
DB_PASSWORD="postgres"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

app = Flask(__name__)

@app.route('/')
def list_products():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM produto;"
        cursor.execute(query)
        return render_template("index.html", cursor=cursor)
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()

@app.route('/categories')
def list_categories():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM categoria;"
        cursor.execute(query)
        return render_template("categories.html", cursor=cursor)
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()

@app.route('/listsubcategories')
def list_subcategories():
    dbConn=None
    cursor=None
    category = request.args.get("category")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "WITH RECURSIVE subcategories AS ( \
        SELECT categoria FROM tem_outra WHERE super_categoria=%s \
        UNION SELECT t.categoria FROM tem_outra t \
        INNER JOIN subcategories s ON s.categoria=t.super_categoria) \
        SELECT * FROM subcategories;"
        cursor.execute(query, (category, ))
        return render_template("listsubcategories.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()

@app.route('/addcategory', methods=["GET"])
def add_category_get():
    try:
        return render_template("addcategory.html")
    except Exception as e:
        return str(e) #Renders a page with the error.

@app.route('/addcategory', methods=["POST"])
def add_category_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        category = request.form["category"]
        super_category = request.form["supercategory"]
        supercategory_dropdown = request.form["supercategorydropdown"]
        subcategory_dropdown = request.form["subcategorydropdown"]
        data = (category, )
        if category == "" or (super_category == "" and subcategory_dropdown == "yes"):
            return redirect("/nerd-express.cgi/addcategory")
        query = "START TRANSACTION; INSERT INTO categoria(nome) VALUES (%s);"
        if subcategory_dropdown == "yes":
            query += "INSERT INTO tem_outra(super_categoria, categoria) VALUES (%s, %s);"  
            data += (super_category, category)
        if supercategory_dropdown == "yes":
            query += "INSERT INTO super_categoria(nome) VALUES (%s);"
            data += (category, )
        query += "COMMIT;"
        cursor.execute(query, data)
        return render_template("success.html")
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/ivms')
def list_ivms():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM ivm;"
        cursor.execute(query)
        return render_template("ivms.html", cursor=cursor)
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()

@app.route('/replenishmentevents')
def list_replenshimentevents():
    dbConn=None
    cursor=None
    serial = request.args.get("serial")
    manuf = request.args.get("manuf")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM evento_reposicao NATURAL JOIN produto NATURAL JOIN retalhista WHERE num_serie=%s AND fabricante=%s"
        cursor.execute(query, (serial, manuf))
        return render_template("replenishmentevents.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e) #Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()

CGIHandler().run(app)

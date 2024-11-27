import psycopg2
from config import config

def connect():
    """ Pripoj se do PostgreSQL db serveru a vykonej SQL prikaz """
    conn = None
    try:
        # 1. nacti parametry 
        params = config()
        print('Pripojuji se do DB...')
        conn = psycopg2.connect(**params)
        # 2. vytvor kurzor (ukazatel) 
        cur = conn.cursor()
        # 3. Vykonej SQL prikaz 
        print('PostgreSQL DB verze:')
        cur.execute('SELECT version()')
        # 4. Zobraz vysledek na standardnim vystupu 
        db_version = cur.fetchone()
        print(db_version)
        # 5. Ukonci komunikaci se serverem 
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close() # 6. Uzavri pripojeni do DB. 
        print('Pripojeni do DB je uzavreno.')

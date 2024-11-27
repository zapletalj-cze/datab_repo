#!/usr/bin/python

"""
Prostorove databaze: cviceni 10
Python - PostgreSQL
"""
"""
TODO:
Úkol 1.
● Vytvořte Python skripty pro přístup do DB a výpis počtu obcí 
v ČR
Úkol 2.
● Vytvořte Python skripty pro přístup do DB a výpis geometrie 
Jihočeského kraje. 
Úkol 3.
● Vytvořte Python skripty pro přístup do DB a řešení 
následující úlohy: 
● Kolik obcí z celkového počtu sousedí s hranicí Jihočeského 
kraje?

"""
import psycopg2
from config import config


def connect():
    """ Pripoj se do PostgreSQL DB serveru """
    conn = None
    try:
        # pripoj PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(host="osgeo.natur.cuni.cz",
                                database="gismentors",
                                user="zapletal",
                                password="gkd2024"
                                )

        # vytvor cursor
        cur = conn.cursor()

        # vykonej SQL prikaz
        cur.execute('SELECT version();')
        db_version = cur.fetchone()
        print(f'PostgreSQL database version: {db_version[0]}')
        cur.execute('SELECT COUNT(*) FROM ruian.obce;')

        # vytiskni PostgreSQL DB verzi na standardni vystup
        db_version = cur.fetchone()
        print(db_version)

        # uzavri komunikaci
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Pripojeni do databaze uzavrena.')


if __name__ == '__main__':
    connect()


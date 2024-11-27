#!/usr/bin/python
from configparser import ConfigParser


def config(filename='database.ini', section='postgresql'):
    # parser konfigurace
    parser = ConfigParser()
    # nacti konfiguracni soubor
    parser.read(filename)

    # nacti postgresql sekci do dict
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Sekce {0} nenalezena v souboru {1}'.format(section, filename))

    return db


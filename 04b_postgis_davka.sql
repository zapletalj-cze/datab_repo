 CREATE TABLE jtable_copy
 (id SERIAL NOT NULL PRIMARY KEY,
 kodbodu CHAR(20),
 geom GEOMETRY NOT NULL
 );


INSERT INTO jtable_copy (id, kodbodu, geom) 
    VALUES 
    (1, 'a', ST_GeomFromText('POINT(13.1 51.0)', 4326)), 
    (2, 'b', ST_GeomFromText('POINT(13.4 51.2)', 4326)),
    (3, 'b', ST_GeomFromText('POINT(14.7 50.3)', 4326))
    ;



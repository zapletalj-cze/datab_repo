## AI generated docs for 03_spatial_querries


ST_CoordDim(geom): This function returns the coordinate dimension of the geometry, which indicates whether the geometry is 2D, 3D, or has a measure dimension (e.g., 2, 3, or 4).

ST_Dimension(geom): This function returns the inherent dimension of the geometry, such as 0 for points, 1 for lines, and 2 for polygons.

ST_IsCollection(geom): This function checks if the geometry is a collection (e.g., a MultiPoint, MultiLineString, or MultiPolygon) and returns a boolean value.

ST_NumGeometries(geom): This function returns the number of geometries within a collection. If the geometry is not a collection, it returns 1.

ST_NumInteriorRings(geom): This function returns the number of interior rings (holes) in a polygon geometry. If the geometry is not a polygon, it returns 0.

ST_IsValid(geom): This function checks if the geometry is valid according to the OGC (Open Geospatial Consortium) standards and returns a boolean value.
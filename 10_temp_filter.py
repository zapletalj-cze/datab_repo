import pandas

df = pandas.read_csv('J:/lukas_data/lucas_data.csv')
print(df.head())
df_filter = df[['POINT_ID', 'GPS_LAT', 'GPS_LONG', 'LC1', 'LC1_PERC', 'PARCEL_AREA_HA', 'DESCRIPTION']]

df_filter.to_csv('J:/lukas_data/lucas_data_filter.csv', index=False)

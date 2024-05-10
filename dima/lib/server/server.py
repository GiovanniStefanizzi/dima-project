from flask import Flask, jsonify, request, send_file
from PIL import Image, ImageDraw
import io
import requests
import matplotlib.pyplot as plt
import urllib.request
import ee

app = Flask(__name__)
@app.route('/api/ndvi', methods=['GET'])
def get_data():
    geopoints = []
    print('GET /api/ndvi')
    points = request.args.get('points')
    #decode points(a json) into a list of geopoints
    points = points.split('|')
    print(points)
    for point in points:
        geopoints.append(list(map(float, point.split(','))))
    eegeopoints = []
    eegeopoints.append(geopoints)
    print(eegeopoints)
    ee.Initialize(project='ee-dima')
    #create a polygon from the geopoints
    region = ee.Geometry.Polygon(eegeopoints)

    s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')

    #s2 = s2.filterDate('2020-01-01', '2020-12-31')

    s2 = s2.filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 10)
    
    #s2 = s2.filterBounds(region)

    #s2 = s2.select(['B4', 'B8'])

    s2 = s2.map(lambda img: img.normalizedDifference(['B8', 'B4']))

    s2 = s2.median()
    s2 = s2.visualize(min=0, max=1, palette=['red', 'yellow', 'green'])
    s2 = s2.clip(region)

    url = s2.getThumbURL({'region': region, 'dimensions': 128, 'format': 'png'})
    print(url)
    return jsonify({"link": url})

if __name__ == '__main__':
    app.run(debug=True)
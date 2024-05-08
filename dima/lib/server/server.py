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
    points = request.args.get('points')
    #decode points(a json) into a list of geopoints
    points = points.split(',')
    points = list(map(float, points))
    geopoints = []
    for i in range(0, len(points), 2):
        geopoints.append([points[i], points[i+1]])
    print(geopoints)
    #create a polygon from the geopoints
    region = ee.Geometry.Polygon(geopoints)
    
    ee.Initialize(project='ee-dima')

    s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')

    #s2 = s2.filterDate('2020-01-01', '2020-12-31')

    s2 = s2.filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 10)

    region = ee.Geometry.Polygon(
            [[[11.737929376400917, 43.51840451313068],
            [11.740103639754658, 43.51718764867549],
            [11.74089305072334, 43.518342362046205],
            [11.741574199616315, 43.5182442286246],
            [11.74159675421542, 43.519153592218395],
            [11.73917439025756, 43.520340978034724],
            [11.7384747898807, 43.5191455356352]]])




    #s2 = s2.filterBounds(region)

    #s2 = s2.select(['B4', 'B8'])

    s2 = s2.map(lambda img: img.normalizedDifference(['B8', 'B4']))

    s2 = s2.median()
    s2 = s2.visualize(min=0, max=1, palette=['red', 'yellow', 'green'])
    s2 = s2.clip(region)

    url = s2.getThumbURL({'region': region, 'dimensions': 256, 'format': 'png'})
    print(url)
    return jsonify({"link": url})

if __name__ == '__main__':
    app.run(debug=True)
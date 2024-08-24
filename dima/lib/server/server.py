from flask import Flask, jsonify, request, send_file
import ee

app = Flask(__name__)



@app.route('/api/ndvi', methods=['GET'])
def get_ndvi():
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

@app.route('/api/ndwi', methods=['GET'])
def get_ndwi():
    geopoints = []
    print('GET /api/ndwi')
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
    # Load a Sentinel image.
    s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
    
    # filter by cloud cover

    s2 = s2.filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 10)
    # calculate NDWI1
    s2 = s2.map(lambda img: img.normalizedDifference(['B8A', 'B11']))
    # display NDWI1
    s2 = s2.median()
    # Clip the image to the region
    s2 = s2.clip(region)
    # Return the image
    s2 = s2.visualize(min=-1, max=1, palette=['red','yellow', 'green'])
    
    url = s2.getThumbURL({'region': region, 'dimensions': 128, 'format': 'png'})
    print(url)
    return jsonify({"link": url})    

@app.route('/api/evi', methods=['GET'])
def get_evi():
    geopoints = []
    print('GET /api/evi')
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
    # Load a Sentinel image.
    s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
    # filter by cloud cover
    s2 = s2.filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 10)
    # calculate NDVI
    s2 = s2.map(lambda img: img.expression('2.5 * ((NIR - RED) / (NIR + 6 * RED - 7.5 * BLUE + 1))', {
        'NIR': img.select('B8'),
        'RED': img.select('B4'),
        'BLUE': img.select('B2')
    }))
    #display EVI
    s2 = s2.median()
    # Clip the image to the region
    s2 = s2.clip(region)
    # Return the image
    s2 = s2.visualize(min=-1, max=1, palette=['red','orange',  'yellow', 'green'])
    
    url = s2.getThumbURL({'region': region, 'dimensions': 128, 'format': 'png'})
    print(url)
    return jsonify({"link": url})   

@app.route('/api/savi', methods=['GET'])
def get_savi():
    geopoints = []
    print('GET /api/savi')
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
    # Load a Sentinel image.
    s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
    # filter by cloud cover
    s2 = s2.filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 10)
    # calculate NDVI
    s2 = s2.map(lambda img: img.expression('1.5 * ((NIR - RED) / (NIR + RED + 0.5))', {
        'NIR': img.select('B8'),
        'RED': img.select('B4')
    }))
    #display SAVI
    s2 = s2.median()
    # Clip the image to the region
    s2 = s2.clip(region)
    # Return the image
    s2 = s2.visualize(min=-1, max=1, palette=['red','orange',  'yellow', 'green'])
    
    url = s2.getThumbURL({'region': region, 'dimensions': 128, 'format': 'png'})
    print(url)
    return jsonify({"link": url})   
    
@app.route('/api/lai', methods=['GET'])
def get_lai():
    geopoints = []
    print('GET /api/lai')
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
    # Load a Sentinel image.
    s2 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
    # filter by cloud cover
    s2 = s2.filterMetadata('CLOUDY_PIXEL_PERCENTAGE', 'less_than', 10)
    # calculate NDVI
    s2 = s2.map(lambda img: img.expression('3.618 * ((NIR - RED) / (NIR + RED + 0.5))', {
        'NIR': img.select('B8'),
        'RED': img.select('B4')
    }))
    #display LAI
    s2 = s2.median()
    # Clip the image to the region
    s2 = s2.clip(region)
    # Return the image
    s2 = s2.visualize(min=0, max=6, palette=['red','orange',  'yellow', 'green'])
    
    url = s2.getThumbURL({'region': region, 'dimensions': 128, 'format': 'png'})
    print(url)
    return jsonify({"link": url})   

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
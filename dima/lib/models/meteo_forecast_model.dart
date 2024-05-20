class MeteoForecast_model {
  
    final List<int> weatherCode;
    final List<double> minTemp;
    final List<double> maxTemp;
    final List<double> precipitation;

    MeteoForecast_model({required this.weatherCode, required this.minTemp, required this.maxTemp, required this.precipitation});
}
using RandomWeatherApi;

namespace SampleWebApplicationCore.Service
{
    public interface IWeatherForecastService
    {
        WeatherForecast[] GetWeatherForecast();
        //string GetWeatherForecast();
    }
}
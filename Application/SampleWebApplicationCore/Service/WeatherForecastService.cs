using RandomWeatherApi;
using System.Text.Json;

namespace SampleWebApplicationCore.Service
{
    public class WeatherForecastService : IWeatherForecastService
    {
        private readonly string _baseUrl;
        private readonly IConfiguration _configuration;

        public WeatherForecastService(IConfiguration configuration)
        {
            _configuration = configuration;
            _baseUrl = _configuration["WeatherForecastApi:BaseUrl"];
        }

        public WeatherForecast[] GetWeatherForecast()
        {
            var client = new HttpClient();
            client.BaseAddress = new Uri(_baseUrl);
            var response = client.GetAsync("/WeatherForecast").Result;
            if (response.IsSuccessStatusCode)
            {
                var data = response.Content.ReadAsStringAsync().Result;
                // Deserialize the JSON data to WeatherForecast array
                //var weatherForecast = JsonSerializer.Deserialize<WeatherForecast[]>(data);                
                var weatherForecast = Newtonsoft.Json.JsonConvert.DeserializeObject<WeatherForecast[]>(data);
                return weatherForecast;
            }
            else
            {
                return new WeatherForecast[]
                {
                        new WeatherForecast
                        {
                            Date = DateOnly.FromDateTime(DateTime.Now),
                            TemperatureC = 20,
                            Summary = "Sunny"
                        }
                };
            }
        }
    }
}

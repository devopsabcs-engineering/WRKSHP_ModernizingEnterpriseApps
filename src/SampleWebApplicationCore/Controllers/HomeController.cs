using Microsoft.AspNetCore.Mvc;
using RandomWeatherApi;
using SampleWebApplicationCore.Data;
using SampleWebApplicationCore.Models;
using SampleWebApplicationCore.Service;
using System.Diagnostics;
using System.Text.Json;

namespace SampleWebApplicationCore.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly SampleWebApplicationCoreContext _context;
        private readonly IWeatherForecastService _weatherForecastService;

        public HomeController(SampleWebApplicationCoreContext context,
            IWeatherForecastService weatherForecastService,
            ILogger<HomeController> logger)
        {
            _logger = logger;
            _context = context;
            _weatherForecastService = weatherForecastService;
        }

        public IActionResult Index()
        {
            ViewBag.Message = "Home page.";

            _logger.LogInformation("Home page visited.");
            try
            {
                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "Home",
                    VersionNumber = typeof(HomeController).Assembly.GetName().Version?.ToString() ?? "Unknown version",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName,
                    EnvironmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Unknown environment"
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error in Home page.");
                Console.WriteLine(e.ToString());
            }

            // get count of all access logs and last visit
            var accessLogCount = _context.AccessLog.Count();
            var lastVisitLog = _context.AccessLog.OrderByDescending(a => a.VisitId).FirstOrDefault();
            var lastVisitAccessDate = lastVisitLog?.AccessDate;
            var lastComputerName = lastVisitLog?.ComputerName;
            ViewBag.AccessLogCount = accessLogCount;
            ViewBag.LastVisit = lastVisitAccessDate;
            ViewBag.LastComputerName = lastComputerName;

            // add semantic version information from assembly
            ViewBag.Version = typeof(HomeController).Assembly.GetName().Version?.ToString() ?? "Unknown version";
            ViewBag.Environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Unknown environment";

            // call weather forecast service
            var weatherForecast = _weatherForecastService.GetWeatherForecast();
            ViewBag.WeatherForecast = weatherForecast.First().ToString();

            return View();
        }

        public IActionResult Privacy()
        {
            ViewBag.Message = "Privacy page.";
            _logger.LogInformation("Privacy page visited.");
            try
            {
                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "Privacy",
                    VersionNumber = typeof(HomeController).Assembly.GetName().Version?.ToString() ?? "Unknown version",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName,
                    EnvironmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Unknown environment"
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error in Privacy page.");
                Console.WriteLine(e.ToString());
            }

            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            ViewBag.Message = "Error page.";
            _logger.LogError("Error page visited.");
            try
            {
                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "Error",
                    VersionNumber = typeof(HomeController).Assembly.GetName().Version?.ToString() ?? "Unknown version",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName,
                    EnvironmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Unknown environment"
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error in Error page.");
                Console.WriteLine(e.ToString());
            }

            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

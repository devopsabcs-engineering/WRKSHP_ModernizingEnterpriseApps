using Microsoft.AspNetCore.Mvc;
using SampleWebApplicationCore.Data;
using SampleWebApplicationCore.Models;
using System.Diagnostics;

namespace SampleWebApplicationCore.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly SampleWebApplicationCoreContext _context;

        public HomeController(SampleWebApplicationCoreContext context,
            ILogger<HomeController> logger)
        {
            _logger = logger;
            _context = context;
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
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName
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
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName
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
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName
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

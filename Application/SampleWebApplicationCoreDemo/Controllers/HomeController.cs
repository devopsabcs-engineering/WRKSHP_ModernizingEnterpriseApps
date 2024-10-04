using Microsoft.AspNetCore.Mvc;
using SampleWebApplicationCoreDemo.Data;
using SampleWebApplicationCoreDemo.Models;
using System.Diagnostics;

namespace SampleWebApplicationCoreDemo.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly SampleWebApplicationCoreDemoContext _context;

        public HomeController(SampleWebApplicationCoreDemoContext context,
            ILogger<HomeController> logger)
        {
            _logger = logger;
            _context = context;
        }

        public IActionResult Index()
        {           

            _logger.LogInformation("Home page visited.");

            // Insert AccessLog record
            // using database context
            try
            {
                var accessLog = new AccessLog
                {
                    PageName = "Home",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while inserting AccessLog record.");
            }

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

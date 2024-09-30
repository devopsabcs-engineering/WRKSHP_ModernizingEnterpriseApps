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

            try
            {
                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "Home",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            // get count of all access logs and last visit
            var accessLogCount = _context.AccessLog.Count();
            var lastVisitLog = _context.AccessLog.OrderByDescending(a => a.VisitId).FirstOrDefault();
            var lastVisitAccessDate = lastVisitLog?.AccessDate;
            ViewBag.AccessLogCount = accessLogCount;
            ViewBag.LastVisit = lastVisitAccessDate;

            return View();
        }

        public IActionResult Privacy()
        {
            ViewBag.Message = "Privacy page.";

            try
            {
                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "Privacy",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            ViewBag.Message = "Error page.";

            try
            {
                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "Error",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SampleWebApplicationCore.Data;
using SampleWebApplicationCore.Models;

namespace SampleWebApplicationCore.Controllers
{
    public class AccessLogsController : Controller
    {
        private readonly ILogger<AccessLogsController> _logger;
        private readonly SampleWebApplicationCoreContext _context;

        public AccessLogsController(SampleWebApplicationCoreContext context,
            ILogger<AccessLogsController> logger)
        {
            _logger = logger;
            _context = context;
        }

        // GET: AccessLogs
        public async Task<IActionResult> Index()
        {
            ViewBag.Message = "Access Logs page.";

            try
            {
                _logger.LogInformation("AccessLogs page visited.");

                // Insert AccessLog record
                // using database context
                var accessLog = new AccessLog
                {
                    PageName = "AccessLogs",
                    VersionNumber = typeof(AccessLogsController).Assembly.GetName().Version?.ToString() ?? "Unknown version",
                    AccessDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ComputerName = Environment.MachineName,
                    EnvironmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Unknown environment"
                };

                _context.AccessLog.Add(accessLog);
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error in AccessLogs page.");
                Console.WriteLine(e.ToString());
            }
            return View(await _context.AccessLog.ToListAsync());
        }

        // GET: AccessLogs/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var accessLog = await _context.AccessLog
                .FirstOrDefaultAsync(m => m.VisitId == id);
            if (accessLog == null)
            {
                return NotFound();
            }

            return View(accessLog);
        }

        // GET: AccessLogs/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: AccessLogs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("VisitId,PageName,AccessDate,ComputerName")] AccessLog accessLog)
        {
            if (ModelState.IsValid)
            {
                _context.Add(accessLog);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(accessLog);
        }

        // GET: AccessLogs/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var accessLog = await _context.AccessLog.FindAsync(id);
            if (accessLog == null)
            {
                return NotFound();
            }
            return View(accessLog);
        }

        // POST: AccessLogs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("VisitId,PageName,AccessDate,ComputerName")] AccessLog accessLog)
        {
            if (id != accessLog.VisitId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(accessLog);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AccessLogExists(accessLog.VisitId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(accessLog);
        }

        // GET: AccessLogs/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var accessLog = await _context.AccessLog
                .FirstOrDefaultAsync(m => m.VisitId == id);
            if (accessLog == null)
            {
                return NotFound();
            }

            return View(accessLog);
        }

        // GET: AccessLogs/DeleteAll
        public async Task<IActionResult> DeleteAll()
        {
            var accessLogs = await _context.AccessLog.ToListAsync();
            if (accessLogs != null)
            {
                _context.AccessLog.RemoveRange(accessLogs);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        // POST: AccessLogs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var accessLog = await _context.AccessLog.FindAsync(id);
            if (accessLog != null)
            {
                _context.AccessLog.Remove(accessLog);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool AccessLogExists(int id)
        {
            return _context.AccessLog.Any(e => e.VisitId == id);
        }
    }
}

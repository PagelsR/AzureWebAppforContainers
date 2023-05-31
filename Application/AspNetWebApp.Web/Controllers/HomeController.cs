using AspNetCoreHero.ToastNotification.Abstractions;
using AspNetWebApp.Web.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace AspNetWebApp.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly INotyfService _notyf;

        public HomeController(ILogger<HomeController> logger, INotyfService notyf)
        {
            _logger = logger;
            _notyf = notyf;
        }

        public IActionResult Index()
        {

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult Notifications()
        {
            string mycount = "4";

            _notyf.Error("Some Error Message - " + mycount);
            _notyf.Warning("Some Warning Message - Closes in 6 secs", 6);
            _notyf.Information("Some Information Message - closes in 4 seconds.", 4);
            _notyf.Custom("Custom Notification - closes in 6 seconds.", 6, "whitesmoke", "fa fa-gear");
            _notyf.Custom("Custom Notification - closes in 8 seconds.", 8, "#B600FF", "fa fa-home");
            _notyf.Custom("Custom Notification for info - closes in 10 seconds.", 10, "#Ff0000", "fa fa-info");
            _notyf.Custom("Custom Notification - closes in 12 seconds. " + mycount, 12, "#B600FF", "fa fa-warning");
            return View();

        }
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
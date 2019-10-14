using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MBDBapp.Controllers
{
    public class WatchListController : Controller
    {
        // GET: WatchList
        public ActionResult Index()
        {
            return View("WatchList");
        }
    }
}
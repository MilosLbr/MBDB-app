using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MBDBapp.Controllers
{
    [AllowAnonymous]
    public class HomeController : Controller
    {
        private MoviesContext _context;

        public HomeController()
        {
            _context = new MoviesContext();
        }

        protected override void Dispose(bool disposing)
        {
            _context.Dispose();
        }

        public ActionResult Index()
        {
            var selectedFilms = _context.Films.Where(f => f.FilmID == 194 || f.FilmID == 188 || f.FilmID == 78).ToList();
                       
            return View(selectedFilms);
        }

        public ActionResult About()
        {

            return View();
        }

        
    }
}
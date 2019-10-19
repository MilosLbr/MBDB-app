using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MBDBapp.DBModels;

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
            var random = new Random();

            int allFilms = _context.Films.Count();

            int randomSkip = random.Next(allFilms - 3);

            // Display three random films on the home page

            var selectedFilms = _context.Films.OrderBy(f => f.FilmName).Skip(randomSkip).Take(3).ToList();
                       
            return View(selectedFilms);
        }

        public ActionResult About()
        {

            return View();
        }

        
    }
}
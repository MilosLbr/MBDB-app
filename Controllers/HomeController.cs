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

            var allFilmIDs = _context.Films.Select( f => new { filmId = f.FilmID }).ToList();

            // Display three random films on the home page

            var first = allFilmIDs[random.Next(allFilmIDs.Count)];
            var second = allFilmIDs[random.Next(allFilmIDs.Count)];
            var third = allFilmIDs[random.Next(allFilmIDs.Count)];

            var selectedFilms = _context.Films.Where(f => f.FilmID == first.filmId || f.FilmID == second.filmId || f.FilmID == third.filmId).ToList();
                       
            return View(selectedFilms);
        }

        public ActionResult About()
        {

            return View();
        }

        
    }
}
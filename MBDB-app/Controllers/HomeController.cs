using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MBDB_datalib;
using MBDB_repositories.Interfaces;
using MBDB_repositories.Implementation;

namespace MBDBapp.Controllers
{
    [AllowAnonymous]
    public class HomeController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;

        public HomeController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public ActionResult Index()
        {
            // Display three random films on the home page

            var selectedFilms = _unitOfWork.Films.GetThreeRandomFilms();
                       
            return View(selectedFilms);
        }

        public ActionResult About()
        {

            return View();
        }

        
    }
}
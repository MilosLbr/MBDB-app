using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MBDB_datalib;
using MBDB_datalib.Dto;
using AutoMapper;
using MBDBapp.Models;
using MBDB_repositories.Interfaces;
using MBDB_repositories.Implementation;

namespace MBDBapp.Controllers
{
    public class FilmsController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;

        public FilmsController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        // GET: Films
        public ActionResult Index()
        {
            if (User.IsInRole(RoleNames.CanManageDatabase))
                return View("List");

            return View("ReadOnlyList");
        }

        [Authorize]
        // GET: Films/Details/5
        public ActionResult Details(int id)
        {            

            var filmFromDb = _unitOfWork.Films.Get(id);

            if (filmFromDb == null)
            {
                return HttpNotFound();
            }

            var filmDto = Mapper.Map<Film, FilmDto>(filmFromDb);

            return View(filmDto);
        }

        // GET: Films/Create
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Create()
        {
            
            var viewModel = new CreateAndEditFilmViewModel
            {
                Certificates = _unitOfWork.Certificates.GetAll(),
                Countries = _unitOfWork.Countries.GetAll(),
                Directors = _unitOfWork.Directors.GetAll(),
                Languages = _unitOfWork.Languages.GetAll(),
                Studios = _unitOfWork.Studios.GetAll()

            };

            return View(viewModel);
        }

        // POST: Films/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Create(CreateAndEditFilmViewModel filmVM)
        {
            if (ModelState.IsValid)
            {
                var filmToAdd = Mapper.Map<CreateAndEditFilmViewModel, Film>(filmVM);

                _unitOfWork.Films.Add(filmToAdd);
                _unitOfWork.Complete();

                return RedirectToAction("Index");
            }

            filmVM.Certificates = _unitOfWork.Certificates.GetAll();
            filmVM.Countries = _unitOfWork.Countries.GetAll();
            filmVM.Directors = _unitOfWork.Directors.GetAll();
            filmVM.Languages = _unitOfWork.Languages.GetAll();
            filmVM.Studios = _unitOfWork.Studios.GetAll();


            return View(filmVM);
        }

        // GET: Films/Edit/5
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Edit(int id)
        {
            var filmFromDb = _unitOfWork.Films.Get(id);

            if (filmFromDb == null)
            {
                return HttpNotFound();
            }
            var viewModel = Mapper.Map<Film, CreateAndEditFilmViewModel>(filmFromDb);

            viewModel.Certificates = _unitOfWork.Certificates.GetAll();
            viewModel.Countries = _unitOfWork.Countries.GetAll();
            viewModel.Directors = _unitOfWork.Directors.GetAll();
            viewModel.Languages = _unitOfWork.Languages.GetAll();
            viewModel.Studios = _unitOfWork.Studios.GetAll();

            return View(viewModel);
        }

        // POST: Films/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Edit( CreateAndEditFilmViewModel filmVM)
        {
            if (ModelState.IsValid)
            {
                var updateFilm = Mapper.Map<CreateAndEditFilmViewModel, Film>(filmVM);

                _unitOfWork.Films.Update(updateFilm);
                _unitOfWork.Complete();

                return RedirectToAction("Index");
            }

            return View(filmVM);
        }

        // GET: Films/Delete/5
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Delete(int id)
        {
            var filmFromDb = _unitOfWork.Films.Get(id);

            if (filmFromDb == null)
            {
                return HttpNotFound();
            }
            return View(filmFromDb);
        }

        // POST: Films/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult DeleteConfirmed(int id)
        {
            var filmFromDb = _unitOfWork.Films.Get(id);
            _unitOfWork.Films.Remove(filmFromDb);

            _unitOfWork.Complete();
            return RedirectToAction("Index");
        }

    }
}

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
            ViewBag.FilmCertificateID = new SelectList(_unitOfWork.Certificates.GetAll(), "CertificateID", "Certificate");
            ViewBag.FilmCountryID = new SelectList(_unitOfWork.Countries.GetAll(), "CountryID", "CountryName");
            ViewBag.FilmDirectorID = new SelectList(_unitOfWork.Directors.GetAll(), "DirectorID", "DirectorName");
            ViewBag.FilmLanguageID = new SelectList(_unitOfWork.Languages.GetAll(), "LanguageID", "Language");
            ViewBag.FilmStudioID = new SelectList(_unitOfWork.Studios.GetAll(), "StudioID", "StudioName");
            return View();
        }

        // POST: Films/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Create([Bind(Include = "FilmID, FilmName,FilmReleaseDate,FilmDirectorID,FilmLanguageID,FilmCountryID,FilmStudioID,FilmSynopsis,FilmRunTimeMinutes,FilmCertificateID,FilmBudgetDollars,FilmBoxOfficeDollars,FilmOscarNominations,FilmOscarWins")] Film tblFilm)
        {
            if (ModelState.IsValid)
            {
                _unitOfWork.Films.Add(tblFilm);
                _unitOfWork.Complete();

                return RedirectToAction("Index");
            }

            ViewBag.FilmCertificateID = new SelectList(_unitOfWork.Certificates.GetAll(), "CertificateID", "Certificate", tblFilm.FilmCertificateID);
            ViewBag.FilmCountryID = new SelectList(_unitOfWork.Countries.GetAll(), "CountryID", "CountryName", tblFilm.FilmCountryID);
            ViewBag.FilmDirectorID = new SelectList(_unitOfWork.Directors.GetAll(), "DirectorID", "DirectorName", tblFilm.FilmDirectorID);
            ViewBag.FilmLanguageID = new SelectList(_unitOfWork.Languages.GetAll(), "LanguageID", "Language", tblFilm.FilmLanguageID);
            ViewBag.FilmStudioID = new SelectList(_unitOfWork.Studios.GetAll(), "StudioID", "StudioName", tblFilm.FilmStudioID);
            return View(tblFilm);
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
            ViewBag.FilmCertificateID = new SelectList(_unitOfWork.Certificates.GetAll(), "CertificateID", "Certificate", filmFromDb.FilmCertificateID);
            ViewBag.FilmCountryID = new SelectList(_unitOfWork.Countries.GetAll(), "CountryID", "CountryName", filmFromDb.FilmCountryID);
            ViewBag.FilmDirectorID = new SelectList(_unitOfWork.Directors.GetAll(), "DirectorID", "DirectorName", filmFromDb.FilmDirectorID);
            ViewBag.FilmLanguageID = new SelectList(_unitOfWork.Languages.GetAll(), "LanguageID", "Language", filmFromDb.FilmLanguageID);
            ViewBag.FilmStudioID = new SelectList(_unitOfWork.Studios.GetAll(), "StudioID", "StudioName", filmFromDb.FilmStudioID);

            return View(filmFromDb);
        }

        // POST: Films/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Edit([Bind(Include = "FilmID,FilmName,FilmReleaseDate,FilmDirectorID,FilmLanguageID,FilmCountryID,FilmStudioID,FilmSynopsis,FilmRunTimeMinutes,FilmCertificateID,FilmBudgetDollars,FilmBoxOfficeDollars,FilmOscarNominations,FilmOscarWins")] Film tblFilm)
        {
            if (ModelState.IsValid)
            {
                _unitOfWork.Films.Update(tblFilm);
                _unitOfWork.Complete();

                return RedirectToAction("Index");
            }

            ViewBag.FilmCertificateID = new SelectList(_unitOfWork.Certificates.GetAll(), "CertificateID", "Certificate", tblFilm.FilmCertificateID);
            ViewBag.FilmCountryID = new SelectList(_unitOfWork.Countries.GetAll(), "CountryID", "CountryName", tblFilm.FilmCountryID);
            ViewBag.FilmDirectorID = new SelectList(_unitOfWork.Directors.GetAll(), "DirectorID", "DirectorName", tblFilm.FilmDirectorID);
            ViewBag.FilmLanguageID = new SelectList(_unitOfWork.Languages.GetAll(), "LanguageID", "Language", tblFilm.FilmLanguageID);
            ViewBag.FilmStudioID = new SelectList(_unitOfWork.Studios.GetAll(), "StudioID", "StudioName", tblFilm.FilmStudioID);
            return View(tblFilm);
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

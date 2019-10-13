using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MBDBapp;
using MBDBapp.Models.Dto;
using AutoMapper;
using MBDBapp.Models;

namespace MBDBapp.Controllers
{
    public class FilmsController : Controller
    {
        private MoviesContext db = new MoviesContext();

        // GET: Films
        public ActionResult Index()
        {
            var films = db.Films.Include(t => t.tblDirector).OrderByDescending(f => f.FilmOscarNominations).ToList();

            if (User.IsInRole(MBDBapp.Models.RoleNames.CanManageDatabase))
                return View("List", films);

            return View("ReadOnlyList");
        }

        [Authorize]
        // GET: Films/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Film tblFilm = db.Films.Find(id);
            if (tblFilm == null)
            {
                return HttpNotFound();
            }

            var filmDto = Mapper.Map<Film, FilmDto>(tblFilm);

            return View(filmDto);
        }

        // GET: Films/Create
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Create()
        {
            ViewBag.FilmCertificateID = new SelectList(db.tblCertificates, "CertificateID", "Certificate");
            ViewBag.FilmCountryID = new SelectList(db.Countries, "CountryID", "CountryName");
            ViewBag.FilmDirectorID = new SelectList(db.Directors, "DirectorID", "DirectorName");
            ViewBag.FilmLanguageID = new SelectList(db.tblLanguages, "LanguageID", "Language");
            ViewBag.FilmStudioID = new SelectList(db.Studios, "StudioID", "StudioName");
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
                db.Films.Add(tblFilm);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.FilmCertificateID = new SelectList(db.tblCertificates, "CertificateID", "Certificate", tblFilm.FilmCertificateID);
            ViewBag.FilmCountryID = new SelectList(db.Countries, "CountryID", "CountryName", tblFilm.FilmCountryID);
            ViewBag.FilmDirectorID = new SelectList(db.Directors, "DirectorID", "DirectorName", tblFilm.FilmDirectorID);
            ViewBag.FilmLanguageID = new SelectList(db.tblLanguages, "LanguageID", "Language", tblFilm.FilmLanguageID);
            ViewBag.FilmStudioID = new SelectList(db.Studios, "StudioID", "StudioName", tblFilm.FilmStudioID);
            return View(tblFilm);
        }

        // GET: Films/Edit/5
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Film tblFilm = db.Films.Find(id);
            if (tblFilm == null)
            {
                return HttpNotFound();
            }
            ViewBag.FilmCertificateID = new SelectList(db.tblCertificates, "CertificateID", "Certificate", tblFilm.FilmCertificateID);
            ViewBag.FilmCountryID = new SelectList(db.Countries, "CountryID", "CountryName", tblFilm.FilmCountryID);
            ViewBag.FilmDirectorID = new SelectList(db.Directors, "DirectorID", "DirectorName", tblFilm.FilmDirectorID);
            ViewBag.FilmLanguageID = new SelectList(db.tblLanguages, "LanguageID", "Language", tblFilm.FilmLanguageID);
            ViewBag.FilmStudioID = new SelectList(db.Studios, "StudioID", "StudioName", tblFilm.FilmStudioID);
            return View(tblFilm);
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
                db.Entry(tblFilm).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.FilmCertificateID = new SelectList(db.tblCertificates, "CertificateID", "Certificate", tblFilm.FilmCertificateID);
            ViewBag.FilmCountryID = new SelectList(db.Countries, "CountryID", "CountryName", tblFilm.FilmCountryID);
            ViewBag.FilmDirectorID = new SelectList(db.Directors, "DirectorID", "DirectorName", tblFilm.FilmDirectorID);
            ViewBag.FilmLanguageID = new SelectList(db.tblLanguages, "LanguageID", "Language", tblFilm.FilmLanguageID);
            ViewBag.FilmStudioID = new SelectList(db.Studios, "StudioID", "StudioName", tblFilm.FilmStudioID);
            return View(tblFilm);
        }

        // GET: Films/Delete/5
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Film tblFilm = db.Films.Find(id);
            if (tblFilm == null)
            {
                return HttpNotFound();
            }
            return View(tblFilm);
        }

        // POST: Films/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = RoleNames.CanManageDatabase)]
        public ActionResult DeleteConfirmed(int id)
        {
            Film tblFilm = db.Films.Find(id);
            db.Films.Remove(tblFilm);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.Entity;
using AutoMapper;
using MBDBapp.DBModels;
using MBDBapp.Models.Dto;
using System.Web.Http.Results;

namespace MBDBapp.Controllers.Api
{
    public class FilmsController : ApiController
    {
        private MoviesContext _context;

        public FilmsController()
        {
            _context = new MoviesContext();
        }

        // GET: api/Films
        public IHttpActionResult Get()
        {
            var filmsFromDb = _context.Films.Include(f => f.tblDirector)
                    .Include(f => f.tblCasts.Select(cas => cas.tblActor))
                    .ToList()
                    .Select(Mapper.Map<Film,FilmDto>);

            return Ok(filmsFromDb);
        }

        // GET: api/Films/5
        public IHttpActionResult Get(int id)
        {

            var filmFromDb = _context.Films.Include(f => f.tblDirector).Single(f => f.FilmID == id);

            return Ok(Mapper.Map<Film, FilmDto>(filmFromDb));
        }

        // POST: api/Films
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/Films/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Films/5
        public void Delete(int id)
        {
        }
    }
}

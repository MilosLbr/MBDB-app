using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.Entity;
using AutoMapper;
using MBDB_datalib;
using MBDB_datalib.Dto;
using MBDB_repositories.Interfaces;
using MBDB_repositories.Implementation;
using Microsoft.AspNet.Identity;
using System.Web.Http.Results;

namespace MBDBapp.Controllers.Api
{
    [Authorize]
    public class FilmsController : ApiController
    {

        private readonly IUnitOfWork _unitOfWork;

        public FilmsController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        // GET: api/Films
        public IHttpActionResult Get()
        {
            var filmsFromDb = _unitOfWork.Films
                    .GetAll()
                    .Select(Mapper.Map<Film,FilmDto>);

            return Ok(filmsFromDb);
        }

        // GET: api/Films/5
        public IHttpActionResult Get(int id)
        {
            var filmFromDb = _unitOfWork.Films.Get(id);

            if(filmFromDb == null)
            {
                return BadRequest("No movie with Id " + id + " found!");
            }

            return Ok(Mapper.Map<Film, FilmDto>(filmFromDb));
        }

        // GET : api/films/like/id
        [HttpGet]
        [Route("api/films/like/{Id}")]
        public IHttpActionResult LikeFilm(int Id)
        {
            
            var likeDislikeDto = _unitOfWork.Users.LikeAFilm(Id);

            if(likeDislikeDto == null)
            {
                return BadRequest("You have already liked this film!");
            }
            else
            {
                return Ok(likeDislikeDto);
            }
        }
        
        // GET : api/films/dislike/id
        [HttpGet]
        [Route("api/films/dislike/{Id}")]
        public IHttpActionResult DislikeFilm(int Id)
        {
            
            var likeDislikeDto = _unitOfWork.Users.DislikeAFilm(Id);

            if(likeDislikeDto == null)
            {
                return BadRequest("You have already disliked this film!");
            }
            else
            {
                return Ok(likeDislikeDto);
            }
        }        
    }
}

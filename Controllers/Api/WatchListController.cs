using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web.Http;
using MBDBapp.Models;
using MBDBapp.Models.Dto;
using Microsoft.AspNet.Identity;
using AutoMapper;

namespace MBDBapp.Controllers.Api
{
    public class WatchListController : ApiController
    {

        private MoviesContext _context;

        public WatchListController()
        {
            _context = new MoviesContext();
        }

        // get
        public IHttpActionResult Get()
        {
            var claimsIdentity = User.Identity as ClaimsIdentity;

            if (claimsIdentity != null)
            {
                // the principal identity is a claims identity.
                // now we need to find the NameIdentifier claim
                var userIdClaim = claimsIdentity.Claims
                    .FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier);

                if (userIdClaim != null)
                {
                    var userIdValue = userIdClaim.Value;

                    var userFromDb = _context.AspNetUsers.Single(u => u.Id.Equals(userIdValue));
                    var usersFilms = userFromDb.tblFilms.ToList();

                    var watchList = Mapper.Map<AspNetUser, UserDto>(userFromDb);


                    return Ok(watchList);
                }
            }



            return Ok();
        }


        // Delete id 
        [HttpDelete]
        public IHttpActionResult Delete(int Id)
        {
            var usrID = User.Identity.GetUserId();

            var userFromDb = _context.AspNetUsers.Include(u => u.tblFilms).Single(u => u.Id.Equals(usrID));
            var filmToRemove = userFromDb.tblFilms.Single(f => f.FilmID == Id);

            userFromDb.tblFilms.Remove(filmToRemove);

            _context.SaveChanges();

            return Ok();
        }
    }
}

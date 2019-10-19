using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Data.Entity;
using System.Web.Http;
using MBDBapp.DBModels;
using MBDBapp.Models.Dto;
using Microsoft.AspNet.Identity;
using AutoMapper;

namespace MBDBapp.Controllers.Api
{
    [Authorize]
    public class CommentsController : ApiController
    {
        private MoviesContext _context;

        public CommentsController()
        {
            _context = new MoviesContext();
        }

        // Get comments for the given film id
        [HttpGet]
        [Route("api/comments/{filmID=filmID}")]
        public IHttpActionResult GetComments(int filmID)
        {
            var commentsFromDb = _context.Comments.Where(c => c.CommentFilmID.Equals(filmID))
                .Join(_context.AspNetUsers,
                c => c.CommentUserID,
                u => u.Id,
                (com, user) =>
                new
                {
                    com.CommentID,
                    com.CommentContent,
                    user.UserName,
                    com.DateAdded
                })
                .ToList();


            return Ok(commentsFromDb);
        }

        // Post a comment to DB
        [HttpPost]
        [Route("api/comments/")]
        public IHttpActionResult PostComment([FromBody]CommentDto commentData)
        {
            var userIdValue = User.Identity.GetUserId();

            var filmID = commentData.CommentFilmID;
            var filmFromDb = _context.Films.SingleOrDefault(f => f.FilmID.Equals(filmID));

            if (filmFromDb == null)
                return BadRequest("Bad movie ID!");
            if (string.IsNullOrEmpty(commentData.CommentContent)
                || string.IsNullOrWhiteSpace(commentData.CommentContent))
                return BadRequest("Can not insert empty comment!");

            commentData.DateAdded = DateTime.Now;
            commentData.CommentUserID = userIdValue;
            
            var commentToAdd = Mapper.Map<CommentDto, Comment>(commentData);

            _context.Comments.Add(commentToAdd);
            _context.SaveChanges();

            commentData.CommentID = commentToAdd.CommentID;

            return Created(new Uri(Request.RequestUri + "/" + commentData.CommentID), commentData);
        }
    }
}

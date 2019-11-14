using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Data.Entity;
using System.Web.Http;
using MBDB_datalib;
using MBDB_datalib.Dto;
using MBDB_repositories.Interfaces;
using MBDB_repositories.Implementation;
using Microsoft.AspNet.Identity;
using AutoMapper;

namespace MBDBapp.Controllers.Api
{
    [Authorize]
    public class CommentsController : ApiController
    {
        private readonly IUnitOfWork _unitOfWork;

        public CommentsController()
        {
            _unitOfWork = new UnitOfWork(new MoviesContext());
        }

        // Get comments for the given film id
        [HttpGet]
        [Route("api/comments/{filmID=filmID}")]
        public IHttpActionResult GetComments(int filmID)
        {
            var commentsFromDb = _unitOfWork.Comments.GetCommentsForGivenFilm(filmID);
            
            return Ok(commentsFromDb);
        }

        // Post a comment to DB
        [HttpPost]
        [Route("api/comments/")]
        public IHttpActionResult PostComment([FromBody]CommentDto commentData)
        {
            var userIdValue = User.Identity.GetUserId();

            var filmID = commentData.CommentFilmID;
            var filmFromDb = _unitOfWork.Films.Get(filmID);

            if (filmFromDb == null)
                return BadRequest("Bad movie ID!");
            if (string.IsNullOrEmpty(commentData.CommentContent)
                || string.IsNullOrWhiteSpace(commentData.CommentContent))
                return BadRequest("Can not insert empty comment!");

            commentData.DateAdded = DateTime.Now;
            commentData.CommentUserID = userIdValue;
            
            var commentToAdd = Mapper.Map<CommentDto, Comment>(commentData);

            _unitOfWork.Comments.Add(commentToAdd);
            _unitOfWork.Complete();

            commentData.CommentID = commentToAdd.CommentID;

            return Created(new Uri(Request.RequestUri + "/" + commentData.CommentID), commentData);
        }
    }
}

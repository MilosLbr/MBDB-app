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

        public CommentsController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
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

            if (string.IsNullOrEmpty(commentData.CommentContent)
                || string.IsNullOrWhiteSpace(commentData.CommentContent))
                return BadRequest("Can not insert empty comment!");


            var commentInserted =_unitOfWork.Comments.PostCommentToDb(commentData);
            _unitOfWork.Complete();

            commentData.CommentID = commentInserted.CommentID;

            return Created(new Uri(Request.RequestUri + "/" + commentData.CommentID), commentData);
        }
    }
}

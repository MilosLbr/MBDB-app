using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_repositories.Interfaces;
using MBDB_datalib;
using MBDB_datalib.Dto;
using AutoMapper;
using System.Web;
using Microsoft.AspNet.Identity;

namespace MBDB_repositories.Implementation
{
    public class CommentRepository : Repository<Comment>, ICommentRepository
    {
        public CommentRepository(MoviesContext context) :base(context)
        {
        }

        public IEnumerable<CommentJsonModel> GetCommentsForGivenFilm(int filmID)
        {
            var commentsFromDb = DbContext.Comments.Where(c => c.CommentFilmID.Equals(filmID))
                .Join(DbContext.AspNetUsers,
                c => c.CommentUserID,
                u => u.Id,
                (com, user) =>
                new CommentJsonModel
                {
                    CommentID = com.CommentID,
                    CommentContent =com.CommentContent,
                    UserName = user.UserName,
                    DateAdded =com.DateAdded
                })
                .OrderByDescending(c => c.DateAdded)
                .ToList();

            return commentsFromDb;
        }

        public Comment PostCommentToDb(CommentDto commentData)
        {
            var userId = HttpContext.Current.User.Identity.GetUserId();

            commentData.DateAdded = DateTime.Now;
            commentData.CommentUserID = userId;

            var commentToAdd = Mapper.Map<CommentDto, Comment>(commentData);
            
            Add(commentToAdd);

            return commentToAdd;
        }

        public MoviesContext DbContext { get { return Context as MoviesContext; } }
    }
}

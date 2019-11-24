using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_datalib;
using MBDB_datalib.Dto;

namespace MBDB_repositories.Interfaces
{
    public interface ICommentRepository : IRepository<Comment>
    {
        IEnumerable<CommentJsonModel> GetCommentsForGivenFilm(int filmID);

        Comment PostCommentToDb(CommentDto comment);
    }
}

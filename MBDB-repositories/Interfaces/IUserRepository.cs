using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_datalib;
using MBDB_datalib.Dto;

namespace MBDB_repositories.Interfaces
{
    public interface IUserRepository : IRepository<AspNetUser>
    {
        LikeDislikeDto LikeAFilm(int Id);
        LikeDislikeDto DislikeAFilm(int Id);
        UserDto GetUsersWatchlist();
        bool AddFilmToWatchList(int Id);
    }
}

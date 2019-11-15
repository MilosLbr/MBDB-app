using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDB_datalib.Dto
{
    public class LikeDislikeDto
    {
        public int? FilmLikes { get; set; }
        public int? FilmDislikes { get; set; }
        public string Message { get; set; }
    }
}
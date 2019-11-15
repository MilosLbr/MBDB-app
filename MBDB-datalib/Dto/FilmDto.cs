using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MBDB_datalib;

namespace MBDB_datalib.Dto
{
    public class FilmDto : FilmMetaData
    {
        public int FilmID { get; set; }
        public DirectorDto Director { get; set; }

        public ICollection <CastDto> CastMembers { get; set; }

        public StudioDto Studio { get; set; }
    }
}
using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MBDB_datalib;

namespace MBDB_datalib.Dto
{
    public class FilmDto 
    {
        public int FilmID { get; set; }

        public string FilmName { get; set; }
        
        public string FilmSynopsis { get; set; }

        public int FilmRunTimeMinutes { get; set; }

        public System.DateTime FilmReleaseDate { get; set; }

        public int FilmDirectorID { get; set; }

        public int FilmLanguageID { get; set; }

        public int FilmCountryID { get; set; }

        public Nullable<int> FilmStudioID { get; set; }

        public Nullable<long> FilmCertificateID { get; set; }

        public Nullable<int> FilmBudgetDollars { get; set; }

        public Nullable<int> FilmBoxOfficeDollars { get; set; }

        public Nullable<int> FilmOscarNominations { get; set; }

        public Nullable<int> FilmOscarWins { get; set; }

        public Nullable<int> FilmLikes { get; set; }
        public Nullable<int> FilmDislikes { get; set; }
        public DirectorDto Director { get; set; }

        public ICollection <CastDto> CastMembers { get; set; }

        public StudioDto Studio { get; set; }
    }
}
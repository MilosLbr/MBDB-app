using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace MBDBapp.Models
{
    public class FilmMetaData
    {


        [Required]
        [StringLength(200)]
        [Display(Name ="Film name")]
        public string FilmName { get; set; }
        [Required]
        [Display(Name = "Synopsis")]
        public string FilmSynopsis { get; set; }

        [Range(1, 1000)]
        [Display(Name = "Runtime (min)")]
        public int FilmRunTimeMinutes { get; set; }

        [Display(Name = "Release date")]
        public System.DateTime FilmReleaseDate { get; set; }
        [Display(Name = "Director")]
        [Required]
        public int FilmDirectorID { get; set; }
        [Display(Name = "Language")]
        [Required]
        public int FilmLanguageID { get; set; }
        [Display(Name = "Country")]
        [Required]
        public int FilmCountryID { get; set; }
        [Display(Name = "Studio")]
        [Required]
        public Nullable<int> FilmStudioID { get; set; }
        [Display(Name = "Certificate")]
        public Nullable<long> FilmCertificateID { get; set; }
        [Display(Name = "Budget ($)")]
        public Nullable<int> FilmBudgetDollars { get; set; }
        [Display(Name = "BoxOffice ($)")]
        public Nullable<int> FilmBoxOfficeDollars { get; set; }
        [Display(Name = "Oscar Nominations")]
        [Range(0, 100)]
        public Nullable<int> FilmOscarNominations { get; set; }
        [Display(Name = "Oscar Wins")]
        [Range(0, 100)]
        public Nullable<int> FilmOscarWins { get; set; }
         
    }
}
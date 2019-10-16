using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace MBDBapp.DBModels
{
    public class FilmMetaData
    {


        [Required]
        [StringLength(200)]
        [Display(Name = "Film name")]
        public string FilmName;
        [Required]
        [Display(Name = "Synopsis")]
        public string FilmSynopsis;

        [Range(1, 1000)]
        [Display(Name = "Runtime (min)")]
        public int FilmRunTimeMinutes;

        [Display(Name = "Release date")]
        public System.DateTime FilmReleaseDate;

        [Required]
        [Display(Name = "Director")]
        public int FilmDirectorID;


        [Required]
        [Display(Name = "Language")]
        public int FilmLanguageID;

        [Required]
        [Display(Name = "Country")]
        public int FilmCountryID;

        [Required]
        [Display(Name = "Studio")]
        public Nullable<int> FilmStudioID;

        [Display(Name = "Certificate")]
        public Nullable<long> FilmCertificateID;
        [Display(Name = "Budget ($)")]
        public Nullable<int> FilmBudgetDollars;
        [Display(Name = "BoxOffice ($)")]
        public Nullable<int> FilmBoxOfficeDollars;
        [Display(Name = "Oscar Nominations")]
        [Range(0, 100)]
        public Nullable<int> FilmOscarNominations;
        [Display(Name = "Oscar Wins")]
        [Range(0, 100)]
        public Nullable<int> FilmOscarWins;
         
    }
}
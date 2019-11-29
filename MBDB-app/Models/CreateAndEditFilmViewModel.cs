using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using MBDB_datalib;

namespace MBDBapp.Models
{
    public class CreateAndEditFilmViewModel
    {
        public int FilmID { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Film name")]
        public string FilmName { get; set; }

        [Required]
        [Display(Name = "Synopsis")]
        public string FilmSynopsis { get; set; }

        [Range(1, 1000)]
        [Display(Name = "Runtime (min)")]
        public int? FilmRunTimeMinutes { get; set; }

        [Display(Name = "Release date")]
        public DateTime? FilmReleaseDate { get; set; }

        [Required]
        [Display(Name = "Director")]
        public int FilmDirectorID { get; set; }

        public IEnumerable<Director> Directors { get; set; }

        [Required]
        [Display(Name = "Language")]
        public int FilmLanguageID { get; set; }

        public IEnumerable<tblLanguage> Languages { get; set; }

        [Required]
        [Display(Name = "Country")]
        public int FilmCountryID { get; set; }

        public IEnumerable<Country> Countries { get; set; }

        [Required]
        [Display(Name = "Studio")]
        public int? FilmStudioID { get; set; }

        public IEnumerable<Studio> Studios { get; set; }

        public Nullable<long> FilmCertificateID { get; set; }
        public IEnumerable<tblCertificate> Certificates { get; set; }

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
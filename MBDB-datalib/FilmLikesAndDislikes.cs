//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MBDB_datalib
{
    using System;
    using System.Collections.Generic;
    
    public partial class FilmLikesAndDislikes
    {
        public int FilmID { get; set; }
        public string UserID { get; set; }
        public byte IsLiked { get; set; }
        public byte IsDisliked { get; set; }
    
        public virtual AspNetUser AspNetUser { get; set; }
        public virtual Film tblFilm { get; set; }
    }
}

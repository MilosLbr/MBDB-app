using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace MBDB_datalib.Dto
{
    public class CommentDto
    {
        public int CommentID { get; set; }
        [Required]
        public string CommentContent { get; set; }
        [Required]
        public int CommentFilmID { get; set; }
        [Required]
        public string CommentUserID { get; set; }
        public System.DateTime DateAdded { get; set; }

    }
}
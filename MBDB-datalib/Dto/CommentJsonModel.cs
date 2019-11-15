using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MBDB_datalib.Dto
{
    public class CommentJsonModel
    {
        public int CommentID { get; set; }
        public string CommentContent { get; set; }
        public string UserName { get; set; }
        public DateTime DateAdded { get; set; }
    }
}

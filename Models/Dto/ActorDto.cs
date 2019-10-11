using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDBapp.Models.Dto
{
    public class ActorDto
    {
        public int ActorID { get; set; }
        public string ActorName { get; set; }
        public Nullable<System.DateTime> ActorDOB { get; set; }
        public string ActorGender { get; set; }

        
    }
}
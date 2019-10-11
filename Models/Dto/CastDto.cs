using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDBapp.Models.Dto
{
    public class CastDto
    {
        public string CastCharacterName { get; set; }

        public virtual ActorDto Actor { get; set; }
    }
}
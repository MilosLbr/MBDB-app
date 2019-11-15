using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDB_datalib.Dto
{
    public class CastDto
    {
        public string CastCharacterName { get; set; }

        public virtual ActorDto Actor { get; set; }
    }
}
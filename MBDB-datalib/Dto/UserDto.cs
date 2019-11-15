using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDB_datalib.Dto
{
    public class UserDto
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public virtual ICollection<FilmDto> Films { get; set; }
    }
}
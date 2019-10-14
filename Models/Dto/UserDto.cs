using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDBapp.Models.Dto
{
    public class UserDto
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public virtual ICollection<FilmDto> Films { get; set; }
    }
}
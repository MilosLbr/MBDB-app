using MBDB_datalib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDBapp.Models
{
    public class UserViewModel
    {
        public string Id { get; set; }
        public string UserName { get; set; }
        public IEnumerable<AspNetRole> UserRoles { get; set; }

    }
}
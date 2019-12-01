using MBDB_datalib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MBDBapp.Models
{
    public class EditUsersViewModel
    {
        public IEnumerable<AspNetRole> AllRoles { get; set; }
        public List<UserViewModel> Users { get; set; }

    }
}
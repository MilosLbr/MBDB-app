using MBDB_datalib;
using MBDB_repositories.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MBDB_repositories.Implementation
{
    public class UserRolesRepository : Repository<AspNetRole>, IUserRolesRepository
    {
        public UserRolesRepository(MoviesContext context):base(context)
        {
        }


        public MoviesContext DbContext
        {
            get { return Context as MoviesContext; }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_datalib;
using MBDB_repositories.Interfaces;

namespace MBDB_repositories.Implementation
{
    public class DirectorRepository : Repository<Director>, IDirectorRepository
    {
        public DirectorRepository(MoviesContext context) :base(context)
        {
        }
    }
}

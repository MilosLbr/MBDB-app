using MBDB_datalib;
using MBDB_repositories.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MBDB_repositories.Implementation
{
    class GenreRepository : Repository<Genre> , IGenreRepository
    {
        public GenreRepository(MoviesContext context) :base(context)
        {
        }
    }
}

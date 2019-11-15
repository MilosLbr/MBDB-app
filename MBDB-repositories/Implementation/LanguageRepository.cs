using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_datalib;
using MBDB_repositories.Interfaces;

namespace MBDB_repositories.Implementation
{
    public class LanguageRepository : Repository<tblLanguage>, ILanguagesRepository
    {
        public LanguageRepository(MoviesContext context) :base(context)
        {
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_repositories.Interfaces;
using MBDB_datalib;

namespace MBDB_repositories.Implementation
{
    public class CertificateRepository : Repository<tblCertificate>, ICertificateRepository
    {
        public CertificateRepository(MoviesContext context) : base(context)
        {
        }
    }
}

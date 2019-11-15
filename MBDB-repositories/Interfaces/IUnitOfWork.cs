using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MBDB_repositories.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IFilmRepository Films { get; }
        IDirectorRepository Directors { get; }
        ICertificateRepository Certificates { get; }
        ICountryRepository Countries { get; }
        ILanguagesRepository Languages { get; }
        IStudioRepository Studios { get; }
        IUserRepository Users { get; }
        ICommentRepository Comments { get; }
        int Complete();
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_repositories.Interfaces;
using MBDB_datalib;

namespace MBDB_repositories.Implementation
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly MoviesContext _context;
        public IFilmRepository Films { get; set; }
        public IDirectorRepository Directors { get; set; }
        public ICertificateRepository Certificates { get; set; }
        public ICountryRepository Countries { get; set; }
        public ILanguagesRepository Languages { get; set; }
        public IStudioRepository Studios { get; set; }
        public IUserRepository Users { get; set; }
        public ICommentRepository Comments { get; set; }
        public IUserRolesRepository Roles { get; set; }

        public UnitOfWork(MoviesContext context)
        {
            _context = context;
            Films = new FilmRepository(_context);
            Directors = new DirectorRepository(_context);
            Certificates = new CertificateRepository(_context);
            Countries = new CountryRepository(_context);
            Languages = new LanguageRepository(_context);
            Studios = new StudioRepository(_context);
            Users = new UserRepository(_context);
            Comments = new CommentRepository(_context);
            Roles = new UserRolesRepository(_context);
        }

        public int Complete()
        {
            return _context.SaveChanges();
        }

        public void Dispose()
        {
            _context.Dispose();
        }
    }
}

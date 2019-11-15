using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_datalib;
using MBDB_repositories.Interfaces;

namespace MBDB_repositories.Implementation
{
    public class FilmRepository : Repository<Film>, IFilmRepository
    {
        public FilmRepository(MoviesContext context) : base(context)
        {
        }

        public IEnumerable<Film> GetThreeRandomFilms()
        {
            var random = new Random();

            int allFilms = moviesContex.Films.ToList().Count();

            int randomSkip = random.Next(allFilms - 3);

            // Display three random films on the home page

            var selectedFilms = moviesContex.Films.ToList().OrderBy(f => f.FilmName).Skip(randomSkip).Take(3).ToList();

            return selectedFilms;
        }

        public MoviesContext moviesContex
        {
            get { return Context as MoviesContext; }
        }
    }
}

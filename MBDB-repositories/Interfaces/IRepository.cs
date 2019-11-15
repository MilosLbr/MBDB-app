using System;
using System.Collections.Generic;
using System.Linq.Expressions;


namespace MBDB_repositories.Interfaces
{
    public interface IRepository<TEntity> where TEntity : class
    {
        // read
        TEntity Get(int Id);
        IEnumerable<TEntity> GetAll();
        IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>> predicate);
        TEntity SingleOrDefault(Expression<Func<TEntity, bool>> predicate);

        // add
        void Add(TEntity entity);
        void AddRange(IEnumerable<TEntity> entities);

        // update
        void Update(TEntity entity);

        // remove
        void Remove(TEntity entity);
        void RemoveRange(IEnumerable<TEntity> entities);

    }
}

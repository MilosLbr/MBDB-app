using MBDB_datalib;
using Moq;
using System.Data.Entity;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MBDB_repositories.Implementation;

namespace MBDB_tests
{
    [TestFixture]
    public class RepositoryTesting
    {
        [Test]
        public void CheckAddFunction()
        {
            var testObject = new TestClass();

            var ctxMock = new Mock<MoviesContext>();
            var dbSetMock = new Mock<DbSet<TestClass>>();
            ctxMock.Setup(x => x.Set<TestClass>()).Returns(dbSetMock.Object);
            dbSetMock.Setup(x => x.Add(It.IsAny<TestClass>())).Returns(testObject);
            
            var uow = new UnitOfWork(ctxMock.Object);
            var rep = new Repository<TestClass>(ctxMock.Object);
            rep.Add(testObject);
            uow.Complete();

            dbSetMock.Verify(x => x.Add(It.Is<TestClass>(y => y == testObject)));
            ctxMock.Verify(x => x.Set<TestClass>());
            ctxMock.Verify(x => x.SaveChanges(), Times.Once);      

        }
        [Test]
        public void CheckRemoveFunction()
        {
            var testObject = new TestClass();

            var ctxMock = new Mock<MoviesContext>();
            var dbSetMock = new Mock<DbSet<TestClass>>();
            ctxMock.Setup(x => x.Set<TestClass>()).Returns(dbSetMock.Object);
            dbSetMock.Setup(x => x.Remove(It.IsAny<TestClass>())).Returns(testObject);

            var uow = new UnitOfWork(ctxMock.Object);
            var rep = new Repository<TestClass>(ctxMock.Object);
            rep.Remove(testObject);
            uow.Complete();

            dbSetMock.Verify(x => x.Remove(It.Is<TestClass>(y => y == testObject)));
            ctxMock.Verify(x => x.Set<TestClass>());
            ctxMock.Verify(x => x.SaveChanges(), Times.Once);
        }
        [Test]
        public void CheckGetFunction()
        {
            var testObject = new TestClass();

            var ctxMock = new Mock<MoviesContext>();
            var dbSetMock = new Mock<DbSet<TestClass>>();
            ctxMock.Setup(x => x.Set<TestClass>()).Returns(dbSetMock.Object);
            dbSetMock.Setup(x => x.Find(It.IsAny<int>())).Returns(testObject);

            var rep = new Repository<TestClass>(ctxMock.Object);
            rep.Get(12);

            dbSetMock.Verify(x => x.Find(It.IsAny<int>()));
            ctxMock.Verify(x => x.Set<TestClass>());
        }

        [Test]
        public void CheckGetAllFunction()
        {
            var testObject1 = new TestClass() { Id = 1 };
            var testObject5 = new TestClass() { Id = 5 };
            var testObject63 = new TestClass() { Id = 63 };
            var testList = new List<TestClass>() { testObject1, testObject5, testObject63 }.AsQueryable();

            var dbSetMock = new Mock<DbSet<TestClass>>();
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.Provider).Returns(testList.Provider);
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.Expression).Returns(testList.Expression);
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.ElementType).Returns(testList.ElementType);
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.GetEnumerator()).Returns(testList.GetEnumerator());

            var ctxMock = new Mock<MoviesContext>();
            ctxMock.Setup(x => x.Set<TestClass>()).Returns(dbSetMock.Object);

            var rep = new Repository<TestClass>(ctxMock.Object);
            var allObjects = rep.GetAll();


            Assert.AreEqual(3, allObjects.Count());
            Assert.AreEqual(testList, allObjects);
        }

        [Test]
        public void CheckFindFunction()
        {
            var testObject1 = new TestClass() { Id = 1 };
            var testObject5 = new TestClass() { Id = 5 };
            var testObject63 = new TestClass() { Id = 63 };
            var testList = new List<TestClass>() { testObject5, testObject63 }.AsQueryable();

            var dbSetMock = new Mock<DbSet<TestClass>>();
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.Provider).Returns(testList.Provider);
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.Expression).Returns(testList.Expression);
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.ElementType).Returns(testList.ElementType);
            dbSetMock.As<IQueryable<TestClass>>().Setup(x => x.GetEnumerator()).Returns(testList.GetEnumerator());

            var ctxMock = new Mock<MoviesContext>();
            ctxMock.Setup(x => x.Set<TestClass>()).Returns(dbSetMock.Object);

            var rep = new Repository<TestClass>(ctxMock.Object);

            var result = rep.Find(el => el.Id >= 5);

            Assert.AreEqual(2, result.Count());
            Assert.AreEqual(testList, result);
        }
    }
}

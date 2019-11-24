using System.Web.Mvc;
using System.Web.Http;
using Unity;
using Unity.Mvc5;
using MBDBapp.Controllers;
using MBDBapp.Controllers.Api;
using MBDB_repositories.Interfaces;
using MBDB_repositories.Implementation;
using Unity.Lifetime;
using Unity.Injection;

namespace MBDBapp
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
			var container = new UnityContainer();

            // register all your components with the container here
            // it is NOT necessary to register your controllers

            // e.g. container.RegisterType<ITestService, TestService>();

            container.RegisterType<AccountController>(new InjectionConstructor());
            container.RegisterType<ManageController>(new InjectionConstructor());


            container.RegisterType<IUnitOfWork, UnitOfWork>(new HierarchicalLifetimeManager());

            DependencyResolver.SetResolver(new UnityDependencyResolver(container));
            GlobalConfiguration.Configuration.DependencyResolver = new Unity.WebApi.UnityDependencyResolver(container);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MBDBapp.Models;
using System.Web.Mvc;
using MBDB_repositories.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace MBDBapp.Controllers
{
    [Authorize(Roles = RoleNames.CanManageDatabase)]
    public class ManageUsersController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;

        public ManageUsersController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }
        // GET: ManageUsers
        public ActionResult Index()
        {
            var allusers = _unitOfWork.Users.GetUsersAndRoles();

            var editUsersVM = new EditUsersViewModel 
            { 
                AllRoles = _unitOfWork.Roles.GetAll(),
                Users = new List<UserViewModel>()
            };

            foreach (var user in allusers)
            {
                var userVM = new UserViewModel
                {
                    UserRoles = user.AspNetRoles,
                    Id = user.Id,
                    UserName = user.UserName
                };

                editUsersVM.Users.Add(userVM);
            }


            return View(editUsersVM);
        }

        //Get: CreateNewRole
        public ActionResult CreateNewRole()
        {
            
            return View();
        } 
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateNewRole(string roleName)
        {
            // var roleIsCreated= _unitOfWork.Roles.CreateNewRole(roleName);
            ApplicationDbContext context = new ApplicationDbContext();

            var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(context));
            if (string.IsNullOrWhiteSpace(roleName))
            {
                ViewBag.errorMessage = "Insert a value";
                return View();
            }

            if (!roleManager.RoleExists(roleName))
            {
                var roleIsCreated = roleManager.Create(new IdentityRole(roleName));

                if (roleIsCreated.Succeeded)
                {
                    _unitOfWork.Complete();
                    return RedirectToAction("Index");
                }
            }

            ViewBag.errorMessage = "That role name already exists";
            return View();            
            
        }
    }
}
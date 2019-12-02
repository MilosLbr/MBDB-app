using AutoMapper;
using MBDB_datalib;
using MBDB_datalib.Dto;
using MBDB_repositories.Interfaces;
using MBDBapp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MBDBapp.Controllers.Api
{
    [Authorize(Roles = RoleNames.CanManageDatabase)]
    public class ManageUsersController : ApiController
    {
        private readonly IUnitOfWork _unitOfWork;

        public ManageUsersController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        [Route("api/manageusers/{userId}")]
        public IHttpActionResult GetAllRolesForGivenUser(string userId)
        {
            var user = _unitOfWork.Users.SingleOrDefault(u => u.Id.Equals(userId));

            var roles = user.AspNetRoles.Select(r => new RoleDto
            {
                Id = r.Id,
                Name = r.Name
            });

            return Ok(roles);
        }

        [HttpPost]
        public IHttpActionResult AddRoleToTheUser(UserAndRoleJsonModel postData)
        {
            var user = _unitOfWork.Users.SingleOrDefault(u => u.Id.Equals(postData.userId));
            var role = _unitOfWork.Roles.SingleOrDefault(r => r.Name.Equals(postData.roleName));

            if (user.AspNetRoles.Contains(role))
            {
                return BadRequest("User is already in that role!");
            }

            user.AspNetRoles.Add(role);

            _unitOfWork.Complete();

            var usersRoles = user.AspNetRoles.Select(r => new RoleDto
            {
                Id = r.Id,
                Name = r.Name
            });

            return Ok(usersRoles);
        }

        [HttpDelete]
        public IHttpActionResult RemoveRoleFromUser(UserAndRoleJsonModel deleteData)
        {
            var role = _unitOfWork.Roles.SingleOrDefault(r => r.Name.Equals(deleteData.roleName));
            var user = _unitOfWork.Users.SingleOrDefault(u => u.Id.Equals(deleteData.userId));

            user.AspNetRoles.Remove(role);
            _unitOfWork.Complete();

            var usersRoles = user.AspNetRoles.Select(r => new RoleDto
            {
                Id = r.Id,
                Name = r.Name
            });

            return Ok(usersRoles);


        }
    }
}

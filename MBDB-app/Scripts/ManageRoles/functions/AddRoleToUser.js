function addRoleToUser() {

    let roleId = rolesDropdown.val();
    let userId = $(this).data('userid');

    let data = {
        roleId,
        userId
    }

    $.ajax({
        url: "/api/manageusers/",
        data: data,
        method: "POST",
    })
        .done((data) => {
            toastr.success("Successfully added a role to this user!");
            fillListOfRolesInModal(data, userId)
        })
        .fail((data) => {
            toastr.error(data.responseJSON.message )
        })

    console.log(roleId, userId, ' role and user');
}
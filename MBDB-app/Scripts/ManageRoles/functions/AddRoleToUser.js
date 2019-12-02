function addRoleToUser() {

    let roleName = rolesDropdown.val();
    let userId = $(this).attr('data-userid');
    console.log(userId, ' sending t0 this id')
    let data = {
        roleName,
        userId
    }

    $.ajax({
        url: "/api/manageusers/",
        data: data,
        method: "POST",
    })
        .done((data) => {
            toastr.success("Successfully added a role to this user!");
            
            $(userRoles).html("");
            let unorderedList = createListOfRoles(data, userId);

            $(userRoles).append(unorderedList);

            updateRolesInTheTable(userId);
        })
        .fail((data) => {
            toastr.error(data.responseJSON.message )
        })

}
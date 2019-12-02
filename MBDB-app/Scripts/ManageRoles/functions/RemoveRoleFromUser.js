function removeRoleFromUser() {
    let userId = $(this).attr("data-userid");
    let roleName = $(this).attr("data-rolename");

    let data = {
        userId,
        roleName
    }

    bootbox.confirm("Are you sure you want to remove " + roleName + " from this user?", (result) => {
        if (result) {
            $.ajax({
                url: "/api/manageusers",
                data: data,
                method: "DELETE"
            })
                .done((data) => {
                    toastr.success("Successfully removed the role from this user!");
                    $(userRoles).html("");
                    let unorderedList = createListOfRoles(data, userId);

                    $(userRoles).append(unorderedList);

                    updateRolesInTheTable(userId);
                })
                .fail((data) => {
                    toastr.error(data.responseJSON.message)
                })
        }
    })

    
}

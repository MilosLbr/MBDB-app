function fillDialog() {
    console.log($(this).data());
    let userNameForDialog = $(this).data("username");
    let userIDForDialog = $(this).data("userid");

    addRoleButton.attr("data-userid", userIDForDialog);

    userNameModalTitle.text(userNameForDialog);

    $.ajax({
        url: "/api/manageusers/" + $(this).data("userid"),

    })
        .done(data => {

            fillListOfRolesInModal(data, userIDForDialog);

        })
        .fail(() => {
            toastr.error("Error happend while getting user's roles");
        });
}

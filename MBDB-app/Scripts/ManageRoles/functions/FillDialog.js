function fillDialog() {
    console.log($(this).data());
    let userNameForDialog = $(this).attr("data-username");
    let userIDForDialog = $(this).attr("data-userid");
    $("span#userName").attr("data-userid", userIDForDialog);

    addRoleButton.attr("data-userid", userIDForDialog);

    userNameModalTitle.text(userNameForDialog);

    $.ajax({
        url: "/api/manageusers/" + $(this).attr("data-userid"),

    })
        .done(data => {
            $(userRoles).html("");
            let unorderedList = createListOfRoles(data, userIDForDialog);

            $(userRoles).append(unorderedList);
        })
        .fail(() => {
            toastr.error("Error happend while getting user's roles");
        });
}

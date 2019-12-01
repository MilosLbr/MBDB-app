function fillListOfRolesInModal(data, userIDForDialog) {
    console.log(data, 'this is recieved');
    $(userRoles).html("");

    $(data).each((ind, el) => {
        let span = $("<span>").text(el.name);
        span.addClass("col-md-6");

        let deleteBtn = $("<button>").addClass("btn btn-danger").text("X");
        deleteBtn.attr("data-roleid", el.id);
        deleteBtn.attr("data-userid", userIDForDialog);

        let listItem = $("<li>");
        listItem.addClass("row justify-content-bw fl-align-center")
        listItem.append(span);
        listItem.append(deleteBtn);

        $(userRoles).append(listItem);
    })
}
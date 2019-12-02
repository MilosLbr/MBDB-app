function updateRolesInTheTable(userId) {
    let tableCell = $("td.userRoles[data-userid=" + userId + "]");

    $.ajax({
        url: "/api/manageusers/" + userId,
    })
        .done(data => {
            $(tableCell).html("");
            let unorderedList = createListOfRolesForTableCell(data);

            $(tableCell).append(unorderedList);
        })
        .fail(() => {
            toastr.error("Error happend while getting user's roles");
        });
}


function createListOfRolesForTableCell(data) {
    let unorderedList = $("<ul>");

    $(data).each((ind, el) => {

        let listItem = $("<li>").text(el.name);

        unorderedList.append(listItem);
    });

    return unorderedList;

}
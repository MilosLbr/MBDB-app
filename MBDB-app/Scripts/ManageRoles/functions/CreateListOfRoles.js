function createListOfRoles(data, userId) {
    
    let unorderedList = $("<ul>");

    $(data).each((ind, el) => {
        let span = $("<span>").text(el.name);
        span.addClass("col-md-6");

        let deleteBtn = $("<button>").addClass("btn btn-danger js-deleteRole").text("X");
        deleteBtn.attr("data-rolename", el.name);
        deleteBtn.attr("data-userid", userId);

        let listItem = $("<li>");
        listItem.addClass("row justify-content-bw fl-align-center")
        listItem.append(span);
        listItem.append(deleteBtn);

        unorderedList.append(listItem);
    });

    return unorderedList;
}
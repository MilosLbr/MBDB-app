let userName, userRoles, usersTable, addRoleButton, rolesDropdown;


function initialize() {
    $(document).ready(function () {
        userNameModalTitle = $("#userName");

        usersTable = $("#usersTable");
        usersTable.on("click", ".username", fillDialog);

        userRoles = $("#userRoles");

        addRoleButton = $("#addRoleBtn");
        addRoleButton.on("click", addRoleToUser);

        rolesDropdown = $("#AllRoles");

    });
}

using System.Web;
using System.Web.Optimization;

namespace MBDBapp
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js",
                        "~/Scripts/DataTables/jquery.dataTables.js",
                        "~/Scripts/DataTables/dataTables.bootstrap.js",
                        "~/Scripts/toastr.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/DetailsPage").Include(
                    "~/Scripts/FilmDetails/functions/AddOmdbApiData.js",
                    "~/Scripts/FilmDetails/functions/LoadComments.js",
                    "~/Scripts/FilmDetails/functions/AddToWatchlist.js",
                    "~/Scripts/FilmDetails/functions/PostComment.js",
                    "~/Scripts/FilmDetails/functions/FormatDate.js",
                    "~/Scripts/FilmDetails/functions/LikeAMovie.js",
                    "~/Scripts/FilmDetails/functions/DislikeAMovie.js",
                    "~/Scripts/FilmDetails/filmDetails.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/ManageRoles").Include(
                "~/Scripts/ManageRoles/functions/CreateListOfRoles.js",
                "~/Scripts/ManageRoles/functions/RemoveRoleFromUser.js",
                "~/Scripts/ManageRoles/functions/UpdateRolesInTheTable.js",
                "~/Scripts/ManageRoles/functions/FillDialog.js",
                "~/Scripts/ManageRoles/functions/AddRoleToUser.js",
                "~/Scripts/ManageRoles/manageRoles.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/bootbox.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/datatables/css/datatables.bootstrap.css",
                      "~/Content/toastr.css",
                      "~/Content/font-awesome.css",
                      "~/Content/site.css"));
        }
    }
}

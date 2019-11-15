using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MBDBapp.Startup))]
namespace MBDBapp
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}

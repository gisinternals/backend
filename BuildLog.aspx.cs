using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public partial class PackageInfo : System.Web.UI.Page
{
    string sdkRoot = "C:\\Inetpub\\wwwroot\\sdk\\";

    
    protected void Page_Load(object sender, EventArgs e)
    {
        string id = this.Request.QueryString["id"];
        if (id == null)
            return;

        string file = sdkRoot + "build-output/" + id + ".html";

        if (File.Exists(file))
        {
            string[] sections = File.ReadAllText(file).Split(new string[] {"<hr/>"}, StringSplitOptions.None);
            for (int i = 1; i <= 30; i++)
            {
                if (i > sections.Length)
                    break;
                Response.Write(sections[sections.Length - i]);
                Response.Write("<hr/>");
            }
        }
        else
            Response.Write("The specified file doesn't exists!");
    }
}

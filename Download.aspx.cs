using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class Download : System.Web.UI.Page
{
    string sdkRoot = "C:\\Inetpub\\wwwroot\\sdk\\";

    protected void Page_Load(object sender, EventArgs e)
    {
        string fileName = this.Request.QueryString["file"];
        if (fileName != null)
        {
            FileInfo file = new FileInfo(sdkRoot + "\\downloads\\" + fileName);
            if (file.Exists)
            {
                Response.Clear();
 	            Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
 	            Response.AddHeader("Content-Length", file.Length.ToString());
 	            Response.ContentType = "application/octet-stream";
 	            Response.WriteFile(file.FullName);
                Response.End();
            }
            else
            {
                Response.Write("This file does not exist.");
            }
        }
        else
        {
            Response.Write("Please provide a file to download.");
        }
    }
}

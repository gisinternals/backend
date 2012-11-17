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
            FileInfo file = new FileInfo(fileName);
            if (file.Exists)
            {
                Response.Clear();
 	            Response.AddHeader("Content-Disposition", "filename=" + file.Name);
 	            Response.AddHeader("Content-Length", file.Length.ToString());
                switch (file.Extension.ToLower())
                {
                    case ".map":
                        Response.ContentType = "text/plain";
                        break;
                    case ".xml":
                        Response.ContentType = "text/plain";
                        break;
                    case ".js":
                        Response.ContentType = "text/plain";
                        break;
                    case ".txt":
                        Response.ContentType = "text/plain";
                        break;
                    case ".html":
                        Response.ContentType = "text/html";
                        break;
                    case ".png":
                        Response.ContentType = "image/png";
                        break;
                    case ".gif":
                        Response.ContentType = "image/gif";
                        break;
                    case ".jpeg":
                        Response.ContentType = "image/jpeg";
                        break;
                    default:
                        Response.ContentType = "application/octet-stream";
                        break;
                }
                if (Response.ContentType.StartsWith("image") && file.Length == 0)
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
            Response.Write("Please provide a file to show.");
        }
    }
}

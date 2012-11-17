using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;

public partial class PackageInfo : System.Web.UI.Page
{
    string sdkRoot = "C:\\Inetpub\\wwwroot\\sdk\\";

    private string GetHtml(string file)
    {
        if (File.Exists(file))
        {
            StringBuilder retval = new StringBuilder();
            using (System.IO.FileStream s = System.IO.File.OpenRead(file))
            {
                using (System.IO.StreamReader reader = new System.IO.StreamReader(s))
                {
                    string line;
                    while ((line = reader.ReadLine()) != null)
                    {
                        if (retval.Length > 0)
                            retval.Append("<br/>");
                        retval.Append(line);
                    }
                    return retval.ToString();
                }
            }
        }
        return "No information available";
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string file = this.Request.QueryString["file"];
        if (file == null)
            return;

        topictitleDiv.InnerHtml = "General Information about the <span class=\"filename\">" + file + "</span> package";

        file = Path.GetFileNameWithoutExtension(file);
        string target = sdkRoot + "downloads\\doc\\" + file + "\\ms_version.txt";
        msversionDiv.InnerText = GetHtml(target);
        target = sdkRoot + "downloads\\doc\\" + file + "\\ms_deps.txt";
        msdepsDiv.InnerHtml = GetHtml(target);
        target = sdkRoot + "downloads\\doc\\" + file + "\\gdal_version.txt";
        gdalversionDiv.InnerHtml = GetHtml(target);
        target = sdkRoot + "downloads\\doc\\" + file + "\\gdal_formats.txt";
        gdalformatsDiv.InnerHtml = GetHtml(target);
        target = sdkRoot + "downloads\\doc\\" + file + "\\ogr_formats.txt";
        ogrformatsDiv.InnerHtml = GetHtml(target);
        target = sdkRoot + "downloads\\doc\\" + file + "\\gdal_deps.txt";
        gdaldepsDiv.InnerHtml = GetHtml(target);
    }
}

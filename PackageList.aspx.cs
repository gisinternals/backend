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

    private string GetDescription(FileInfo file)
    {
        if (Regex.Match(file.Name, @"gdal-.*-core\.msi", RegexOptions.IgnoreCase).Success)
            return "Generic installer for the GDAL core components";

        if (Regex.Match(file.Name, @"gdal-.*-ecw\.msi", RegexOptions.IgnoreCase).Success)
            return "Installer for the GDAL ECW plugin (must be installed to the same directory as the GDAL core)";

        if (Regex.Match(file.Name, @"gdal-.*-oracle\.msi", RegexOptions.IgnoreCase).Success)
            return "Installer for the GDAL Oracle plugin (must be installed to the same directory as the GDAL core, make sure the proper version of oci.dll is available on your system)";

        if (Regex.Match(file.Name, @"gdal-.*-mrsid\.msi", RegexOptions.IgnoreCase).Success)
            return "Installer for the GDAL MrSID plugin (must be installed to the same directory as the GDAL core)";

        if (Regex.Match(file.Name, @"gdal-.*-filegdb\.msi", RegexOptions.IgnoreCase).Success)
            return "Installer for the OGR FileGDB plugin (must be installed to the same directory as the GDAL core)";

        if (Regex.Match(file.Name, @"GDAL-.*py.*\.(exe|msi)", RegexOptions.IgnoreCase).Success)
            return "Installer for the GDAL python bindings (requires to install the GDAL core)";

        if (Regex.Match(file.Name, @"MapScript-.*py.*\.(exe|msi)", RegexOptions.IgnoreCase).Success)
            return "Installer for the MapScript python bindings (Not yet working)";
        
        return "";
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string fileIn = this.Request.QueryString["file"];
        if (fileIn == null)
            return;

        StringBuilder contents = new StringBuilder();

        string dirName = Path.GetFileNameWithoutExtension(fileIn);
               
        contents.AppendLine("<p>Available downloads (<b>" + dirName + "</b>):</p>");
        contents.AppendLine("<table>");
        contents.AppendLine("<tr><th>File name</th><th>Date of compilation</th><th>Size</th><th>Description</th>");

        if (File.Exists(sdkRoot + "downloads\\" + fileIn))
        {
            FileInfo file = new FileInfo(sdkRoot + "downloads\\" + fileIn);
            contents.AppendLine("<tr><td><a href=\"Download.aspx?file=" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>Compiled binaries in a single .zip package</td></tr>");
        }

        if (File.Exists(sdkRoot + "downloads\\" + dirName + "-src.zip"))
        {
            FileInfo file = new FileInfo(sdkRoot + "downloads\\" + dirName + "-src.zip");
            contents.AppendLine("<tr><td><a href=\"Download.aspx?file=" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>GDAL and MapServer sources</td></tr>");
        }

        if (File.Exists(sdkRoot + "downloads\\" + dirName + "-libs.zip"))
        {
            FileInfo file = new FileInfo(sdkRoot + "downloads\\" + dirName + "-libs.zip");
            contents.AppendLine("<tr><td><a href=\"Download.aspx?file=" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>Compiled libraries and headers</td></tr>");
        }

        DirectoryInfo di = new DirectoryInfo(sdkRoot + "downloads\\" + dirName);
        if (di.Exists)
        {
            FileInfo[] files = di.GetFiles();

            foreach (FileInfo file in files)
            {
                contents.AppendLine("<tr><td><a href=\"Download.aspx?file=" + dirName + "\\" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>" + GetDescription(file) + "</td></tr>");
            }
        }

        contents.AppendLine("</table>");
        if (di.Exists)
        {
            contents.AppendLine("<p><span class=\"note\">Note:</span> In order to have the bindings work the location of the core components must be included manually in the PATH environment variable.</p>");
        }
        
        filelistDiv.InnerHtml = contents.ToString();
        
    }
}

﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;

public partial class _Default : System.Web.UI.Page 
{
    string sdkRoot = "C:\\Inetpub\\wwwroot\\sdk\\";
    string serverRoot = "";

    private void AppendTableRow(StringBuilder s, string title, string file, string logid)
    {
        string id = Path.GetFileNameWithoutExtension(file);
        
        s.Append("<tr>");
        s.Append("<td class=\"title\">" + title + "</td>"); 
        s.Append("<td><a href=\"PackageList.aspx?file=" + file + "\">" + id + "</a></td>");
        s.Append("<td><a href=\"PackageInfo.aspx?file=" + file + "\">information</a></td>");
        s.Append("<td>");
        if (File.Exists(sdkRoot + "build-output\\" + logid + ".html"))
            s.Append("<a href=\"BuildLog.aspx?id=" + logid + "\">buildlog</a>&nbsp;|&nbsp;<a href=\"MSAutotest.aspx?id=" + logid + "&failures=true\">msautotest</a>");
        s.Append("<td>");
        if (File.Exists(sdkRoot + "build-output\\status-" + logid + ".html"))
            s.Append(File.ReadAllText(sdkRoot + "build-output\\status-" + logid + ".html"));
        s.Append("</td>");

        // adding the revision info
        s.Append("<td>");
        string rev = "";
        string revisionfile = sdkRoot + "downloads\\doc\\" + id + "\\ms_revision.txt";
        int rev_number;
        if (File.Exists(revisionfile))
        {
            rev = File.ReadAllText(revisionfile);
            int pos = rev.LastIndexOf("revision");
            if (pos >= 0)
            {
                rev = rev.Substring(pos + 9).Split(new char[] { '.', '\n', '\r' })[0];
                if (int.TryParse(rev, out rev_number))
                    rev = "<a href=\"http://trac.osgeo.org/mapserver/changeset/" + rev + "\">r" + rev + "</a>";
            }
            else if (rev.Length == 40)
            {
                // github
                rev = "<a href=\"https://github.com/mapserver/mapserver/commit/" + rev + "\">" + rev.Substring(0,10) + "</a>";
            }
        }
        
        s.Append(rev);
        
        revisionfile = sdkRoot + "downloads\\doc\\" + id + "\\gdal_revision.txt";
        if (File.Exists(revisionfile))
        {
            rev = File.ReadAllText(revisionfile);
            int pos = rev.LastIndexOf("revision");
            if (pos >= 0)
            {
                rev = rev.Substring(pos + 9).Split(new char[] { '.', '\n', '\r' })[0];
                if (int.TryParse(rev, out rev_number))
                    rev = ",&nbsp<a href=\"http://trac.osgeo.org/gdal/changeset/" + rev + "\">r" + rev + "</a>";
            }
            else if (rev.Length == 40)
            {
                // github
                rev = "<a href=\"https://github.com/gdal/gdal/commit/" + rev + "\">" + rev.Substring(0, 10) + "</a>";
            }
        }
        s.Append(rev);
        s.Append("</td>");
        s.Append("</tr>"); 
    }

    private void AppendTableRowOsgeo4w(StringBuilder s, string title, string downloadlink, string logid)
    {
        s.Append("<tr>");
        s.Append("<td class=\"title\"><a target=\"_blank\" href=\"" + downloadlink + "\">" + title + "</a></td>");
        s.Append("<td>");
        if (File.Exists(sdkRoot + "build-output\\" + logid + ".html"))
            s.Append("<a href=\"BuildLog.aspx?id=" + logid + "\">buildlog</a>");
        s.Append("</td>");
        s.Append("<td>");
        if (File.Exists(sdkRoot + "build-output\\status-" + logid + ".html"))
            s.Append(File.ReadAllText(sdkRoot + "build-output\\status-" + logid + ".html"));
        s.Append("</td>");
        s.Append("</tr>");
    }

    private void AppendTableHtmlCurrent(StringBuilder s, string postfix, string id, string version)
    {
        AppendTableRow(s, "MSVC2005 (Win32) -" + postfix, "release-1400-" + version + ".zip", "vc8-" + id);
        AppendTableRow(s, "MSVC2005 (Win64) -" + postfix, "release-1400-x64-" + version + ".zip", "vc8x64-" + id);
        AppendTableRow(s, "MSVC2008 (Win32) -" + postfix, "release-1500-" + version + ".zip", "vc9-" + id);
        AppendTableRow(s, "MSVC2008 (Win64) -" + postfix, "release-1500-x64-" + version + ".zip", "vc9x64-" + id);
        AppendTableRow(s, "MSVC2010 (Win32) -" + postfix, "release-1600-" + version + ".zip", "vc10-" + id);
        AppendTableRow(s, "MSVC2010 (Win64) -" + postfix, "release-1600-x64-" + version + ".zip", "vc10x64-" + id);
    }

    private void AppendTableHtml(StringBuilder s, string postfix, string id, string version)
    {
        //AppendTableRow(s, "MSVC2003 (Win32) -" + postfix, "release-1310-" + version + ".zip", "vc7-" + id);
        AppendTableRow(s, "MSVC2005 (Win32) -" + postfix, "release-1400-" + version + ".zip", "vc8-" + id);
        AppendTableRow(s, "MSVC2005 (Win64) -" + postfix, "release-1400-x64-" + version + ".zip", "vc8x64-" + id);
        AppendTableRow(s, "MSVC2008 (Win32) -" + postfix, "release-1500-" + version + ".zip", "vc9-" + id);
        AppendTableRow(s, "MSVC2008 (Win64) -" + postfix, "release-1500-x64-" + version + ".zip", "vc9x64-" + id);
        AppendTableRow(s, "MSVC2010 (Win32) -" + postfix, "release-1600-" + version + ".zip", "vc10-" + id);
        AppendTableRow(s, "MSVC2010 (Win64) -" + postfix, "release-1600-x64-" + version + ".zip", "vc10x64-" + id);
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder s = new StringBuilder("<table><tr><th>Compiler (Platform)</th><th>Downloads</th><th>Package Info</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtmlCurrent(s, "development", "dev", "gdal-mapserver");
        AppendTableHtmlCurrent(s, "stable", "stable-1.11-6-4", "gdal-1-11-mapserver-6-4");
        s.Append("</table>");
        binariesDiv.InnerHtml = s.ToString();

        s = new StringBuilder("<table><tr><th>Compiler (Platform)</th><th>Downloads</th><th>Package Info</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.11-6-4", "gdal-1-11-1-mapserver-6-4-1");
        s.Append("</table>");
        releasesDiv.InnerHtml = s.ToString();

        s = new StringBuilder("<table><tr><th>Compiler (Platform)</th><th>Downloads</th><th>Package Info</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtmlCurrent(s, "sdk", "sdk", "dev");
        s.Append("</table>");
        sdkDiv.InnerHtml = s.ToString();

        s = new StringBuilder("<table><tr><th>Package</th><th>Build log</th><th>Build status</th></tr>");
        AppendTableRowOsgeo4w(s, "mapserver (x86)", "http://download.osgeo.org/osgeo4w/x86/release/mapserver/mapserver/", "vc10-osgeo4w-release");
        AppendTableRowOsgeo4w(s, "mapserver-dev (x86)", "http://download.osgeo.org/osgeo4w/x86/release/mapserver/mapserver-dev/", "vc10-osgeo4w-dev");
        AppendTableRowOsgeo4w(s, "mapserver-stable-dev (x86)", "http://download.osgeo.org/osgeo4w/x86/release/mapserver/mapserver-stable-dev/", "vc10-osgeo4w-stable-dev");
        AppendTableRowOsgeo4w(s, "mapserver (x64)", "http://download.osgeo.org/osgeo4w/x86_64/release/mapserver/mapserver/", "vc10x64-osgeo4w-release");
        AppendTableRowOsgeo4w(s, "mapserver-dev (x64)", "http://download.osgeo.org/osgeo4w/x86_64/release/mapserver/mapserver-dev/", "vc10x64-osgeo4w-dev");
        AppendTableRowOsgeo4w(s, "mapserver-stable-dev (x64)", "http://download.osgeo.org/osgeo4w/x86_64/release/mapserver/mapserver-stable-dev/", "vc10x64-osgeo4w-stable-dev");
        s.Append("</table>");
        osgeo4wDiv.InnerHtml = s.ToString();

        s = new StringBuilder("<table><tr><th>Package</th><th>Build log</th><th>Build status</th></tr>");
        AppendTableRowOsgeo4w(s, "MapManager (MapServer release)", "PackageList.aspx?file=release-1600-gdal-1-10-1-mapserver-6-4-1.zip", "vc10-mapmanager-release");
        AppendTableRowOsgeo4w(s, "MapManager (MapServer stable-dev)", "PackageList.aspx?file=release-1600-gdal-1-10-mapserver-6-4.zip", "vc10-mapmanager-stable-dev");
        s.Append("</table>");
        mapmanagerDiv.InnerHtml = s.ToString();

        s = new StringBuilder("<table><tr><th>Compiler (Platform)</th><th>Downloads</th><th>Package Info</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.11-6-4", "gdal-1-11-0-mapserver-6-4-1");
        AppendTableHtml(s, "release", "released-1.10-6-4", "gdal-1-10-1-mapserver-6-4-1");
        AppendTableHtml(s, "release", "released-1.10-6-4", "gdal-1-10-1-mapserver-6-4-0");
        AppendTableHtml(s, "release", "released-1.10-6-2", "gdal-1-10-0-mapserver-6-2-1");
        AppendTableHtml(s, "release", "released-1.9-6-2", "gdal-1-9-2-mapserver-6-2-0");
        AppendTableHtml(s, "release", "released-1.9-6-0", "gdal-1-9-1-mapserver-6-0-3");
        AppendTableHtml(s, "release", "released-1.9-6-0", "gdal-1-9-0-mapserver-6-0-1");
        AppendTableHtml(s, "release", "released-1.8-6-0", "gdal-1-8-1-mapserver-6-0-1");
        AppendTableHtml(s, "release", "released-1.8-6-0", "gdal-1-8-0-mapserver-6-0-0");
        AppendTableHtml(s, "release", "released-1.8-5-6", "gdal-1-8-0-mapserver-5-6-6");
        AppendTableHtml(s, "release", "released-1.7-5-6", "gdal-1-7-3-mapserver-5-6-5");
        s.Append("</table>");
        olderDiv.InnerHtml = s.ToString();
    }
}

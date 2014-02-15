<%@ WebHandler Language="C#" Class="GetContent" %>

using System;
using System.Web;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;

public class GetContent : IHttpHandler {

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
            return "Installer for the GDAL Oracle plugin (must be installed to the same directory as the GDAL core)";

        if (Regex.Match(file.Name, @"gdal-.*-mrsid\.msi", RegexOptions.IgnoreCase).Success)
            return "Installer for the GDAL MrSID plugin (must be installed to the same directory as the GDAL core)";

        if (Regex.Match(file.Name, @"GDAL-.*py.*\.(exe|msi)", RegexOptions.IgnoreCase).Success)
            return "Installer for the GDAL python bindings (requires to install the GDAL core)";

        if (Regex.Match(file.Name, @"MapScript-.*py.*\.(exe|msi)", RegexOptions.IgnoreCase).Success)
            return "Installer for the MapScript python bindings (Not yet working)";

        return "";
    }

    private void AppendTableRow(StringBuilder s, string title, string file, string logid)
    {
        string id = Path.GetFileNameWithoutExtension(file);

        s.Append("<tr>");
        s.Append("<td class=\"title\"><a href=\"query.html?content=filelist&file=" + file + "\">" + title + "</a></td>");
        s.Append("<td>");
        if (File.Exists(sdkRoot + "build-output\\" + logid + ".html"))
            s.Append("<a href=\"query.html?content=buildlog&id=" + logid + "\">buildlog</a>&nbsp;|&nbsp;<a href=\"query.html?content=msautotest&id=" + logid + "&failures=true\">msautotest</a>");
        s.Append("<td>");
        
        if (File.Exists(sdkRoot + "build-output\\status-" + logid + ".html"))
            s.Append(File.ReadAllText(sdkRoot + "build-output\\status-" + logid + ".html").Trim());
        s.Append("</td>");

        if (!logid.EndsWith("sdk"))
        {
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
                    rev = "<a href=\"https://github.com/mapserver/mapserver/commit/" + rev + "\">" + rev.Substring(0, 10) + "</a>";
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
        }
        s.Append("</tr>");
    }

    private void AppendTableHtml(StringBuilder s, string postfix, string id, string version)
    {
        AppendTableRow(s, "MSVC2005 (Win32)", "release-1400-" + version + ".zip", "vc8-" + id);
        AppendTableRow(s, "MSVC2005 (Win64)", "release-1400-x64-" + version + ".zip", "vc8x64-" + id);
        AppendTableRow(s, "MSVC2008 (Win32)", "release-1500-" + version + ".zip", "vc9-" + id);
        AppendTableRow(s, "MSVC2008 (Win64)", "release-1500-x64-" + version + ".zip", "vc9x64-" + id);
        if (File.Exists(sdkRoot + "\\downloads\\release-1600-" + version + ".zip"))
        {
            AppendTableRow(s, "MSVC2010 (Win32)", "release-1600-" + version + ".zip", "vc10-" + id);
            AppendTableRow(s, "MSVC2010 (Win64)", "release-1600-x64-" + version + ".zip", "vc10x64-" + id);
        }
    }

    private void ProcessBuildStatus(HttpContext context)
    {
        context.Response.Write("<h1>Current Build Status</h1>");

        StringBuilder s = new StringBuilder("<h2><a href=\"development.html\">Development Versions</a></h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "development", "dev", "gdal-mapserver");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2><a href=\"stable.html\">Stable Branches</a></h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "stable", "stable-1.9-6-0", "gdal-1-9-mapserver-6-0");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2><a href=\"release.html\">Release Versions</a></h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.9-6-0", "gdal-1-9-1-mapserver-6-0-3");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2><a href=\"sdk.html\">Development Kits</a></h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th></tr>");
        AppendTableHtml(s, "sdk", "sdk", "dev");
        s.Append("</table>");
        context.Response.Write(s.ToString());
    }

    private void ProcessArchive(HttpContext context)
    {
        context.Response.Write("<h1>Archive versions</h1>");

        StringBuilder s = new StringBuilder("<h2>gdal-1-10-1-mapserver-6-4-0</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.10-6-4", "gdal-1-10-1-mapserver-6-4-0");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-10-0-mapserver-6-2-1</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.10-6-2", "gdal-1-10-0-mapserver-6-2-1");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-9-2-mapserver-6-2-0</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.9-6-2", "gdal-1-9-2-mapserver-6-2-0");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-9-1-mapserver-6-0-3/h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.9-6-0", "gdal-1-9-1-mapserver-6-0-3");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-9-0-mapserver-6-0-1</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.9-6-0", "gdal-1-9-0-mapserver-6-0-1");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-8-1-mapserver-6-0-1</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.8-6-0", "gdal-1-8-1-mapserver-6-0-1");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-8-0-mapserver-6-0-0</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.8-6-0", "gdal-1-8-0-mapserver-6-0-0");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-8-0-mapserver-5-6-6</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.8-5-6", "gdal-1-8-0-mapserver-5-6-6");
        s.Append("</table>");
        context.Response.Write(s.ToString());

        s = new StringBuilder("<h2>gdal-1-7-3-mapserver-5-6-5</h2>");
        s.Append("<table><tr><th>Compiler (Platform)</th><th>Build log</th><th>Build status</th><th>Latest revision</th></tr>");
        AppendTableHtml(s, "release", "released-1.7-5-6", "gdal-1-7-3-mapserver-5-6-5");
        s.Append("</table>");
        context.Response.Write(s.ToString());
    }
    
    private void ProcessFilelist(HttpContext context)
    {
        string fileIn = context.Request["file"];
        if (fileIn == null)
        {
            context.Response.Write("No file have been specified.");
            return;
        }

        string baseUrl = context.Request.Url.Scheme + "://" + context.Request.Url.Authority + context.Request.ApplicationPath.TrimEnd('/') + '/';

        StringBuilder contents = new StringBuilder();

        string dirName = Path.GetFileNameWithoutExtension(fileIn);

        contents.Append("<p>Available downloads (<b>" + dirName + "</b>):</p>");

        contents.Append("<table>");
        contents.Append("<tr><th>File name</th><th>File date</th><th>Size</th><th>Description</th>");

        if (File.Exists(sdkRoot + "downloads\\" + fileIn))
        {
            FileInfo file = new FileInfo(sdkRoot + "downloads\\" + fileIn);
            contents.Append("<tr><td><a href=\"" + baseUrl + "Download.aspx?file=" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>Compiled binaries in a single .zip package</td></tr>");
        }

        if (File.Exists(sdkRoot + "downloads\\" + dirName + "-src.zip"))
        {
            FileInfo file = new FileInfo(sdkRoot + "downloads\\" + dirName + "-src.zip");
            contents.Append("<tr><td><a href=\"" + baseUrl + "Download.aspx?file=" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>GDAL and MapServer sources</td></tr>");
        }

        if (File.Exists(sdkRoot + "downloads\\" + dirName + "-libs.zip"))
        {
            FileInfo file = new FileInfo(sdkRoot + "downloads\\" + dirName + "-libs.zip");
            contents.Append("<tr><td><a href=\"" + baseUrl + "Download.aspx?file=" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>Compiled libraries and headers</td></tr>");
        }

        DirectoryInfo di = new DirectoryInfo(sdkRoot + "downloads\\" + dirName);
        if (di.Exists)
        {
            FileInfo[] files = di.GetFiles();

            foreach (FileInfo file in files)
            {
                contents.Append("<tr><td><a href=\"" + baseUrl + "Download.aspx?file=" + dirName + "/" + file.Name + "\">" + file.Name + "</a></td><td>" + file.LastWriteTime.ToShortDateString() + " " + file.LastWriteTime.ToShortTimeString() + "</td><td>" + Math.Round((double)file.Length / 1024).ToString() + " kB</td><td>" + GetDescription(file) + "</td></tr>");
            }
        }

        contents.Append("</table>");
        if (di.Exists)
        {
            contents.Append("<p><span class=\"note\">Note:</span> In order to have the bindings work the location of the core components must be included manually in the PATH environment variable.</p>");
        }
        context.Response.Write(contents.ToString());
    }

    private void ProcessPackageinfo(HttpContext context)
    {
        string file = context.Request.QueryString["file"];
        if (file == null)
        {
            context.Response.Write("No file have been specified.");
            return;
        }

        
    }

    private void ProcessChangeLog(HttpContext context)
    {
        string[] log = File.ReadAllLines("E:\\builds\\changelog.txt");

        for (int i = log.Length - 1; i >= 0; --i)
        {
            context.Response.Write(log[i].Substring(2));
            context.Response.Write("<br/>");
        }
    }

    private void ProcessText(HttpContext context)
    {
        string file = context.Request.QueryString["file"];
        if (file == null)
        {
            context.Response.Write("No file have been specified.");
            return;
        }
        context.Response.Write(GetHtml(sdkRoot + file).Replace("\t","").Replace("\r","").Replace("\n",""));
    }

    private void ProcessBuildLog(HttpContext context)
    {
        string id = context.Request.QueryString["id"];
        if (id == null)
            return;

        string file = sdkRoot + "build-output\\" + id + ".html";

        if (File.Exists(file))
        {
            string[] sections = File.ReadAllText(file).Split(new string[] { "<hr/>" }, StringSplitOptions.None);
            for (int i = 1; i <= 30; i++)
            {
                if (i > sections.Length)
                    break;
                context.Response.Write(sections[sections.Length - i].Replace("\r\n", ""));
                context.Response.Write("<hr/>");
            }
            
            
            //using (System.IO.FileStream s = System.IO.File.OpenRead(file))
            //{
            //    using (System.IO.StreamReader reader = new System.IO.StreamReader(s))
            //    {
            //        string line;
            //        while ((line = reader.ReadLine()) != null)
            //        {
            //            context.Response.Write(line/*.Replace("http://www.gisinternals.com/sdk/", "query.html?content=text&file=")*/);
            //        }
            //    }
            //}
        }
        else
            context.Response.Write("The specified file doesn't exists!");
    }

    public void ProcessMSAutotest(HttpContext context)
    {
        string id = context.Request.QueryString["id"];
        if (id == null)
            return;

        string failures = context.Request.QueryString["failures"];

        string file = sdkRoot + "build-output/" + id + ".html";

        if (!File.Exists(file))
        {
            context.Response.Write("The specified file doesn't exists!");
            return;
        }

        // finding out the latest msautotest output
        string[] lines = File.ReadAllLines(file);
        string[] tokens;
        StringBuilder html = new StringBuilder();

        for (int i = lines.Length - 1; i >= 0; --i)
        {
            if (lines[i].Contains("MapServer autotest started"))
            {
                tokens = lines[i].Split(new string[] { "<a href=\"", "&nbsp", "\">stdout</a>", "\">stderr</a>" }, StringSplitOptions.RemoveEmptyEntries);

                string resultfile = tokens[1].Replace("http://www.gisinternals.com/sdk/", sdkRoot);

                if (!File.Exists(resultfile))
                {
                    resultfile = tokens[1].Replace("http://vbkto.dyndns.org:1280/sdk/", sdkRoot);
                    if (!File.Exists(resultfile))
                    {
                        context.Response.Write("Unable to find autotest results!");
                        return;
                    }
                }

                // parsing the autotest results
                lines = File.ReadAllLines(resultfile);
                string autotest_dir = lines[0].Substring(4);
                string testdir = "";
                string mapfile = "";
                string mapfilepath = "";
                string results = "";
                string requires = "";

                List<string> run_params = new List<string>();
                List<string> out_files = new List<string>();
                int run_count = 0;
                string[] renderers = new string[] { "", ".png24", ".png" };
                int current_renderer = 0;

                html.AppendLine("<h1>Test results for <span class=\"filename\">" + id + "</span></h1>");
                html.AppendLine("<p>The raw outputs of the tests are avalilable from these direct links: <a href=\"" + tokens[1] + "\">stdout</a>&nbsp;<a href=\"" + tokens[2] + "\">stderr</a></p>");
                if (failures == null)
                    html.AppendLine("<p>Click <a href=\"MSAutotest.aspx?id=" + id + "&failures=true\">here</a> to show the failures only.</p>");
                else
                    html.AppendLine("<p>Click <a href=\"MSAutotest.aspx?id=" + id + "\">here</a> to show all results.</p>");

                for (int j = 1; j < lines.Length; j++)
                {
                    if (lines[j].Contains("cd gdal"))
                    {
                        if (testdir != "")
                            html.AppendLine("</table>");

                        current_renderer = 0;

                        html.AppendLine("<h2>gdal test results</h2>");
                        html.AppendLine("<table>");
                        html.AppendLine("<tr><th>MapFile</th><th>Result</th><th>Expected File</th><th>Result File</th><th>Requires</th><th>Run Params</th></tr>");

                        testdir = autotest_dir + "\\gdal\\";
                    }
                    if (lines[j].Contains("cd misc"))
                    {
                        if (testdir != "")
                            html.AppendLine("</table>");

                        current_renderer = 0;

                        html.AppendLine("<h2>misc test results</h2>");
                        html.AppendLine("<table>");
                        html.AppendLine("<tr><th>MapFile</th><th>Result</th><th>Expected File</th><th>Result File</th><th>Requires</th><th>Run Params</th></tr>");

                        testdir = autotest_dir + "\\misc\\";
                    }
                    if (lines[j].Contains("cd wxs"))
                    {
                        if (testdir != "")
                            html.AppendLine("</table>");

                        current_renderer = 0;

                        html.AppendLine("<h2>wxs test results</h2>");
                        html.AppendLine("<table>");
                        html.AppendLine("<tr><th>MapFile</th><th>Result</th><th>Expected File</th><th>Result File</th><th>Requires</th><th>Run Params</th></tr>");

                        testdir = autotest_dir + "\\wxs\\";
                    }
                    if (lines[j].Contains("cd renderers"))
                    {
                        if (testdir != "")
                            html.AppendLine("</table>");

                        current_renderer = 1;

                        html.AppendLine("<h2>renderers test results</h2>");
                        html.AppendLine("<p>renderer = <span style=\"color:Blue;font-weight:bold\">" + renderers[current_renderer].Substring(1) + "</span></p>");
                        html.AppendLine("<table>");
                        html.AppendLine("<tr><th>MapFile</th><th>Result</th><th>Expected File</th><th>Result File</th><th>Requires</th><th>Run Params</th></tr>");

                        testdir = autotest_dir + "\\renderers\\";
                    }
                    if (lines[j].Contains("cd query"))
                    {
                        if (testdir != "")
                            html.AppendLine("</table>");

                        current_renderer = 0;

                        html.AppendLine("<h2>query test results</h2>");
                        html.AppendLine("<table>");
                        html.AppendLine("<tr><th>MapFile</th><th>Result</th><th>Expected File</th><th>Result File</th><th>Requires</th><th>Run Params</th></tr>");

                        testdir = autotest_dir + "\\query\\";
                    }
                    if (lines[j].StartsWith("Test done"))
                    {
                        if (testdir != "")
                            html.AppendLine("</table>");

                        // collect summary
                        StringBuilder summary = new StringBuilder("Summary of the test: ");
                        summary.Append("<span style=\"color:Green;font-weight:bold\">" + lines[j].Substring(10) + "</span>");
                        if (++j < lines.Length)
                            summary.Append(" " + lines[j]);
                        if (++j < lines.Length)
                            summary.Append(", " + lines[j]);
                        if (++j < lines.Length)
                            summary.Append(", " + lines[j]);
                        if (++j < lines.Length)
                            summary.Append(", " + lines[j]);
                        if (++j < lines.Length && lines[j].Contains("Serious Failure!"))
                            summary.Append(", " + lines[j].Replace("Serious Failure!", "<span style=\"color:Red;font-weight:bold\">Serious Failure!</span>"));

                        html.AppendLine("<p>" + summary + "</p>");

                        if (current_renderer > 0)
                            ++current_renderer;

                        if (current_renderer == renderers.Length)
                            current_renderer = 0;
                        else if (current_renderer > 0)
                        {
                            html.AppendLine("<p>renderer = <span style=\"color:Blue;font-weight:bold\">" + renderers[current_renderer].Substring(1) + "</span></p>");
                            html.AppendLine("<table>");
                            html.AppendLine("<tr><th>MapFile</th><th>Result</th><th>Expected File</th><th>Result File</th><th>Requires</th><th>Run Params</th></tr>");
                        }
                    }
                    if (lines[j].StartsWith("   test"))
                    {
                        string testFile = lines[j].Substring(8);

                        if (run_params.Count == run_count || testFile != out_files[run_count])
                        {
                            // There's something
                            continue;
                        }

                        // read result
                        if (j < lines.Length - 1)
                            results = lines[j + 1].Substring(1).Trim().Replace("TEST FAILED", "<span style=\"color:Red;font-weight:bold\">TEST FAILED</span>");
                        else
                            results = "";

                        if (failures != null && !results.Contains("TEST FAILED"))
                        {
                            ++j;
                            ++run_count;
                            continue;
                        }

                        string expected = testdir + "expected\\" + out_files[run_count];
                        if (File.Exists(expected))
                            expected = "<a href=\"ShowFile.aspx?file=" + testdir + "expected\\" + out_files[run_count] + "\">" + out_files[run_count] + "</a>";
                        else
                            expected = "";

                        string result = testdir + "result\\" + out_files[run_count];
                        if (!results.Contains("results match") && File.Exists(result))
                            result = "<a href=\"ShowFile.aspx?file=" + testdir + "result\\" + out_files[run_count] + "\">" + out_files[run_count] + "</a>";
                        else
                            result = "";

                        StringBuilder run_param = new StringBuilder(run_params[run_count]);
                        run_param.Replace("[MAPSERV]", "mapserv.exe");
                        run_param.Replace("[LEGEND]", "legend.exe");
                        run_param.Replace("[SCALEBAR]", "scalebar.exe");
                        run_param.Replace("[SHP2IMG]", "shp2img.exe");
                        run_param.Replace("[MAPFILE]", mapfile);
                        run_param.Replace("[RESULT]", out_files[run_count]);
                        run_param.Replace("[RESULT_DEMIME]", out_files[run_count]);
                        run_param.Replace("[RESULT_DEVERSION]", out_files[run_count]);
                        run_param.Replace("[POST]", "\"");
                        run_param.Replace("[/POST]", "\"");

                        if (current_renderer > 0)
                            run_param.Replace("[RENDERER]", "-i " + renderers[current_renderer].Substring(1));
                        else
                            run_param.Replace("[RENDERER]", "");

                        html.AppendLine("<tr><td><a href=\"ShowFile.aspx?file=" + mapfilepath + "\">" + mapfile + "</a></td><td>" + results + "</td><td>" + expected + "</td><td>" + result + "</td><td>" + requires + "</td><td>" + run_param.ToString() + "</td></tr>");

                        ++run_count;
                        ++j; // skip result row
                    }
                    if (lines[j].StartsWith(" Processing:"))
                    {
                        mapfile = lines[j].Substring(13);
                        mapfilepath = testdir + mapfile;

                        requires = "";

                        if (File.Exists(mapfilepath))
                        {
                            string[] maplines = File.ReadAllLines(mapfilepath);
                            run_params.Clear();
                            out_files.Clear();
                            run_count = 0;

                            foreach (string mapline in maplines)
                            {
                                if (mapline.Contains("REQUIRES:"))
                                    requires = mapline.Substring(12).Trim();
                                else if (mapline.Contains("RUN_PARMS:"))
                                {
                                    string[] items = mapline.Substring(13).Trim().Split();
                                    if (items.Length >= 2)
                                    {
                                        StringBuilder cmdLine = new StringBuilder(items[1]);
                                        out_files.Add(items[0]);
                                        for (int c = 2; c < items.Length; c++)
                                        {
                                            cmdLine.Append(" " + items[c]);
                                        }
                                        run_params.Add(cmdLine.ToString());
                                    }
                                    else if (items.Length == 1)
                                    {
                                        out_files.Add(items[0]);
                                        run_params.Add("[SHP2IMG] [RENDERER] -m [MAPFILE] -o [RESULT]");
                                    }
                                }
                            }

                            if (run_params.Count == 0)
                            {
                                out_files.Add(mapfile.Replace(".map", renderers[current_renderer] + ".png"));
                                run_params.Add("[SHP2IMG] [RENDERER] -m [MAPFILE] -o [RESULT]");
                            }

                            // single test case
                            if (run_params.Count == 1)
                            {
                                // read result
                                if (j < lines.Length - 1)
                                    results = lines[j + 1].Substring(1).Trim().Replace("TEST FAILED", "<span style=\"color:Red;font-weight:bold\">TEST FAILED</span>");
                                else
                                    results = "";

                                if (failures != null && !results.Contains("TEST FAILED"))
                                {
                                    ++j;
                                    continue;
                                }

                                string expected = testdir + "expected\\" + out_files[0];
                                if (File.Exists(expected))
                                    expected = "<a href=\"ShowFile.aspx?file=" + testdir + "expected\\" + out_files[0] + "\">" + out_files[0] + "</a>";
                                else
                                    expected = "";

                                string result = testdir + "result\\" + out_files[0];
                                if (!results.Contains("results match") && File.Exists(result))
                                    result = "<a href=\"ShowFile.aspx?file=" + testdir + "result\\" + out_files[0] + "\">" + out_files[0] + "</a>";
                                else
                                    result = "";

                                StringBuilder run_param = new StringBuilder(run_params[0]);
                                run_param.Replace("[MAPSERV]", "mapserv.exe");
                                run_param.Replace("[LEGEND]", "legend.exe");
                                run_param.Replace("[SCALEBAR]", "scalebar.exe");
                                run_param.Replace("[SHP2IMG]", "shp2img.exe");
                                run_param.Replace("[MAPFILE]", mapfile);
                                run_param.Replace("[RESULT]", out_files[0]);
                                run_param.Replace("[RESULT_DEMIME]", out_files[0]);
                                run_param.Replace("[RESULT_DEVERSION]", out_files[0]);
                                run_param.Replace("[POST]", "\"");
                                run_param.Replace("[/POST]", "\"");

                                if (current_renderer > 0)
                                    run_param.Replace("[RENDERER]", "-i " + renderers[current_renderer].Substring(1));
                                else
                                    run_param.Replace("[RENDERER]", "");

                                html.AppendLine("<tr><td><a href=\"ShowFile.aspx?file=" + mapfilepath + "\">" + mapfile + "</a></td><td>" + results + "</td><td>" + expected + "</td><td>" + result + "</td><td>" + requires + "</td><td>" + run_param.ToString() + "</td></tr>");

                                ++j; // skip result row
                            }
                        }
                    }
                }

                if (testdir != "")
                    html.AppendLine("</table>");

                break;
            }
        }
    }
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Write(context.Request["callback"]);
        context.Response.Write("({'html': '");
        switch (context.Request["content"])
        {
            case "filelist":
                ProcessFilelist(context);
                break;

            case "packageinfo":
                ProcessPackageinfo(context);
                break;

            case "changelog":
                ProcessChangeLog(context);
                break;
                
            case "buildlog":
                ProcessBuildLog(context);
                break;

            case "status":
                ProcessBuildStatus(context);
                break;

            case "archive":
                ProcessArchive(context);
                break;

            case "text":
                ProcessText(context);
                break;

            case "msautotest":
                ProcessMSAutotest(context);
                break;  

            default:
                context.Response.Write("Content not available at server.");
                break;

        }
        context.Response.Write("'})");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}
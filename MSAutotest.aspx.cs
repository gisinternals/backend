using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

public partial class MSAutotest : System.Web.UI.Page
{
    string sdkRoot = "C:\\Inetpub\\wwwroot\\sdk\\";

   
    protected void Page_Load(object sender, EventArgs e)
    {
        string id = this.Request.QueryString["id"];
        if (id == null)
            return;

        string failures = this.Request.QueryString["failures"];

        string file = sdkRoot + "build-output/" + id + ".html";

        if (!File.Exists(file))
        {
            Response.Write("The specified file doesn't exists!");
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
                tokens = lines[i].Split(new string[] {"<a href=\"", "&nbsp", "\">stdout</a>", "\">stderr</a>"}, StringSplitOptions.RemoveEmptyEntries);

                string resultfile = tokens[1].Replace("http://www.gisinternals.com/sdk/", sdkRoot);

                if (!File.Exists(resultfile))
                {
                    resultfile = tokens[1].Replace("http://vbkto.dyndns.org:1280/sdk/", sdkRoot);
                    if (!File.Exists(resultfile))
                    {
                        Response.Write("Unable to find autotest results!");
                        return;
                    }
                }

                // parsing the autotest results
                lines = File.ReadAllLines(resultfile);
                string autotest_dir = lines[0].Substring(4);
                if (!autotest_dir.Contains("E:\\builds"))
                    autotest_dir = lines[2].Substring(4);
                string testdir = "";
                string mapfile = "";
                string mapfilepath = "";
                string results = "";
                string requires = "";

                List<string> run_params = new List<string>();
                List<string> out_files = new List<string>();
                int run_count = 0;
                string[] renderers = new string[] { "", ".png24", ".png"};
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

        filelistDiv.InnerHtml = html.ToString();
    }
}

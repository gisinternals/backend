<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="verify-v1" content="sLQdYo6WZHl34ea7SY2YSaqfp+GeQgQdY+09pTB/UKc=" />
    <meta name="google-site-verification" content="jbgktup44Q6o1__XY80P9WOAsBWXhcu0bV_a2bKOw3I" />
    <title>MapServer and GDAL binary and SDK packages</title>
    <link rel="stylesheet" type="text/css" href="SDKStyle.CSS" />
    <style type="text/css">
        .style1
        {
            color: #FF0000;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    
    
    
    
    <span class="topictitle">This page contains the links to the most recent versions of the build SDKs 
and the related binary packages </span>

<p>This build environment compiles <a href="http://www.gdal.org/">GDAL</a> and <a href="http://mapserver.org/">MapServer</a> from the subversion and provide cutting edge binary packages containing the latest fixes until the time when build has started (refer to build log for the details). 
Only the binaries of the latest successful builds are available to download. The possible breaking changes in the subversion causes the compilation to terminate immediately before the packaging is started.</p>
<p><span class="note">Note:</span> The different compilers or platforms involve different CRT dependencies, therefore the binaries of the different packages are not interchangeable.</p>
<p>The contents of the packages are provided under the terms of <a href="license.txt">this license</a>. It is intended to give you permission to do whatever you want with the files: download, modify, redistribute as you please, including building proprietary commercial software, no permission from Tamas Szekeres is required. Some external libraries which can be optionally used by GDAL and MapServer (provided as plugins) are under radically different licenses, you <strong>MUST obtain valid licenses</strong> for each of these dependent libraries.</p>
    <p><span class="style1">Reporting issues or enhancement requests related to the 
        build system can be posted to the</span> <b>
        <a href="https://github.com/gisinternals/buildsystem/issues/new">github issue 
        tracker</a></b>.</p>
        
 

<h2>The following binary only packages are compiled daily based on 
the MapServer and GDAL SVN (development and stable branches):</h2>

<div id="binariesDiv" runat="server"></div>

<h2>GDAL and MapServer latest release versions:</h2>
<div id="releasesDiv" runat="server"></div>

<h2>
GDAL and MapServer build SDK packages (provides to compile MapServer and GDAL by 
yourself):</h2>

<div id="sdkDiv" runat="server"></div>

<p>For the compilation instructions refer to the <a href="readme.txt">readme.txt</a> contained by the 
packages. The supported versions of the libraries can be found in the /doc 
subdirectory
</p>

<h2>Older releases (not compiled regularly):</h2>

<div id="olderDiv" runat="server"></div>

<p>
    These packages are maintained by <a href="mailto:szekerest@gmail.com">Tamas Szekeres</a> feel free to drop me a mail if you have problems or suggestions. Any feedback is highly appreciated.</p>
    <p>To get further information about the development follow the posts on <a href="http://szekerest.blogspot.com/">my blog</a>.</p>
    <hr/>
    
    
    
    
    
    
    </form>
 <script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-13269500-1");
pageTracker._trackPageview();
} catch(err) {}</script>
</body>
</html>

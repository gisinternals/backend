<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PackageInfo.aspx.cs" Inherits="PackageInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Package Information</title>
    <link rel="stylesheet" type="text/css" href="SDKStyle.CSS" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="topictitleDiv" runat="server" class="topictitle"></div>
    <p>This package contains all the required files to successfully run <a href="http://mapserver.org/">MapServer</a> and <a href="http://www.gdal.org/">GDAL</a> related applications on Windows.
    The files are organized according to the following directory layout:</p>
    <div class="sample">
    <ul>
    <li><span class="menuitem">\bin</span> - Contains the common dll files. </li>
    <li><span class="menuitem">\bin\gdal</span> - Contains the GDAL related directories. </li>
    <li><span class="menuitem">\bin\gdal\apps</span> - <a href="http://www.gdal.org/gdal_utilities.html">GDAL utilities</a> and <a href="http://www.gdal.org/ogr_utilities.html">OGR utilities</a>. </li>
    <li><span class="menuitem">\bin\gdal\csharp</span> - Compiled binary files of the GDAL/OGR CSharp bindings. </li>
    <li><span class="menuitem">\bin\gdal\java</span> - Compiled binary files of the GDAL/OGR Java bindings. </li>
    <li><span class="menuitem">\bin\gdal\python</span> - Compiled binary files of the GDAL/OGR Python bindings. </li>
    <li><span class="menuitem">\bin\gdal\plugins</span> - GDAL plugin dll-s.</li>
    <li><span class="menuitem">\bin\ms</span> -  Binary files of the MapServer related directories. </li>
    <li><span class="menuitem">\bin\ms\apps</span> - <a href="http://mapserver.org/utilities/index.html">MapServer utilities</a>. </li>
    <li><span class="menuitem">\bin\ms\csharp</span> - Compiled binary files of the MapScript CSharp bindings. </li>
    <li><span class="menuitem">\bin\ms\java</span> - Compiled binary files of the MapScript Java bindings. </li>
    <li><span class="menuitem">\bin\ms\python</span> - Compiled binary files of the MapScript Python bindings. </li>
    <li><span class="menuitem">\bin\ms\plugins</span> - MapServer plugin dll-s.</li>
    <li><span class="menuitem">\bin\proj\apps</span> -  Contains the Proj.4 related utilities. </li>
    <li><span class="menuitem">\doc</span> - Contains package and version information files. </li>
    <li><span class="menuitem">changelog.txt</span> - Text file about the package changes. </li>
     </ul>
     </div>
    
    <h2>General Installation Notes</h2>
    <p>In order to run the utility programs the compiled dll-s should be available to load during the execution. 
    Therefore the <strong>PATH</strong> environment parameter should contain the full path to /bin directory of the package or the dlls in this directory should be copied into the directory from which the application (executable) is running</p>
    <h2>Installing the GDAL/OGR plugins</h2>
    <p>Some of the GDAL/OGR drivers/data sources have been compiled as plugin dlls located in the <strong>\bin\gdal\plugins</strong> subdirectory. 
    When executing the GDAL/OGR related applications the plugins should be available to load by the driver manager. For this reason the corresponding dll-s should be copied into a <strong>\gdalplugins</strong> subdirectory from where the application executable is running.
    As an alternative solution the <strong>GDAL_DRIVER_PATH</strong> could also be set to point to the location of the plugin dll-s.</p>
    <p><span class="note">Note:</span> When using the Oracle and SDE plugins be sure that the client libraries have been installed in the environment previously.</p>
    <h2>Using the MapServer plugins</h2>
    <p>The mapserver plugin dll-s can be found in the <strong>\bin\ms\plugins</strong> subdirectory. 
    In order to use the plugins you have to modify the mapfile according to the following example: </p>
    <div id="Div1" class="sample">
    LAYER <br/>
    &nbsp&nbsp CONNECTIONTYPE PLUGIN <br/>
    &nbsp&nbsp PLUGIN "msplugin_mssql2008.dll" <br/>
    &nbsp&nbsp CONNECTION "server=.\MSSQLSERVER2008;database=geodb;Integrated Security=true" <br/>
    &nbsp&nbsp DATA "geom from rivers WITH(INDEX(geom_sidx)) USING UNIQUE ID USING SRID=0" <br/>
    &nbsp&nbsp ...<br/>
    END 
    </div>
    <p><span class="note">Note:</span> When using the Oracle and SDE plugins (Win32 packages only) be sure that the client libraries have been installed in the environment previously.</p>
    <h2>MapServer Version Information</h2>
    <p>The compiled MapServer reports the following version information. (mapserv -v)</p>
    <div id="msversionDiv" runat="server" class="sample"></div>
    <h2>Libraries used for the MapServer Compilation</h2>
    <p>MapServer have been compiled using the following dependent libraries</p>
    <div id="msdepsDiv" runat="server" class="sample"></div>
    <h2>GDAL Version Information</h2>
    <p>The compiled GDAL reports the following version information. (gdalinfo --version)</p>
    <div id="gdalversionDiv" runat="server" class="sample"></div>
    <h2>Supported GDAL Formats</h2>
    <p>The compiled GDAL package reports the following supported formats. (gdalinfo --formats). For more information about the GDAL formats visit: <a href="http://www.gdal.org/formats_list.html">GDAL Raster Formats</a></p>
    <div id="gdalformatsDiv" runat="server" class="sample"></div>
    <h2>Supported OGR Formats</h2>
    <p>The compiled OGR package reports the following supported formats. (ogrinfo --formats) For more information about the OGR formats visit: <a href="http://www.gdal.org/ogr/ogr_formats.html">OGR Vector Formats</a></p>
    <div id="ogrformatsDiv" runat="server" class="sample"></div>
    <h2>Libraries used for the GDAL Compilation</h2>
    <p>GDAL have been compiled using the following dependent libraries</p>
    <div id="gdaldepsDiv" runat="server" class="sample"></div>
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

<%@ WebHandler Language="C#" Class="PackageList" %>

using System;
using System.Web;
using System.IO;


public class PackageList : IHttpHandler {

    string sdkRoot = "C:\\Inetpub\\wwwroot\\sdk\\";
    
    public void ProcessRequest (HttpContext context) {
        //context.Response.ContentType = "application/x-javascript";
        //context.Response.Write(File.ReadAllText(sdkRoot + "json.txt"));
        //context.Response.Write("({'one': 'Singular sensation', 'two': 'Beady little eyes', 'three': 'Little birds pitch by my doorstep'})");

        context.Response.ContentType = "application/json";

        //DateTime dateStamp = DateTime.Parse((string)context.Request.Form["dateStamp"]);
        //string stringParam = (string)context.Request.Form["stringParam"];

        // Your logic here 

        string json = "{ \"responseDateTime\": \"hello hello there!\" }";
        context.Response.Write(json);     
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
}
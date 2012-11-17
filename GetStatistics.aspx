<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetStatistics.aspx.cs" Inherits="GetStatistics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script language='javascript' type="text/javascript">
        function timedRefresh(timeoutPeriod) {
            setTimeout("location.reload(true);", timeoutPeriod);
        }
  </script> 
</head>
<body onload="JavaScript:timedRefresh(5000);">
    <form id="form1" runat="server">
    <div>
    <table>
    <tr>
     <td>Total Number of Users</td><td><asp:label id="lblTotalNumberOfUsers" runat="server"></asp:label></td>
     </tr>
     <tr>
     <td>Current User Count</td><td><asp:label id="lblCurrentNumberOfUsers" runat="server"></asp:label></td>
     </tr>
     <tr>
     <td>Current Time</td><td><asp:label id="lblTime" runat="server"></asp:label></td>
     </tr>
    </table>
    </div>
    </form>
</body>
</html>

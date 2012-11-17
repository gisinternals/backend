using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class GetStatistics : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblCurrentNumberOfUsers.Text = ASP.global_asax.CurrentNumberOfUsers.ToString();
        lblTotalNumberOfUsers.Text = ASP.global_asax.TotalNumberOfUsers.ToString();
        lblTime.Text = DateTime.Now.ToLongDateString() + " " + DateTime.Now.ToLongTimeString();
    }
}

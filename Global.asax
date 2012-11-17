<%@ Application Language="C#" %>

<script runat="server">

    private static int totalNumberOfUsers = 0;
    private static int currentNumberOfUsers = 0;
    private string statFile = "C:\\Inetpub\\wwwroot\\sdk\\statistics.txt";

    private int ReadInteger(System.IO.StreamReader reader)
    {
        string line = reader.ReadLine();
        if (line != null)
        {
            int value;
            if (int.TryParse(line, out value))
                return value;
        }
        return 0;
    }
    
    void Application_Start(object sender, EventArgs e) 
    {
        if (System.IO.File.Exists(statFile))
        {
            using (System.IO.FileStream s = System.IO.File.OpenRead(statFile))
            {
                using (System.IO.StreamReader reader = new System.IO.StreamReader(s))
                {
                    totalNumberOfUsers = ReadInteger(reader);
                }
            }
        }
    }

    private void SaveStatistics()
    {
        using (System.IO.FileStream s = System.IO.File.OpenWrite(statFile))
        {
            using (System.IO.StreamWriter writer = new System.IO.StreamWriter(s))
            {
                writer.WriteLine(totalNumberOfUsers.ToString());
            }
        }
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        totalNumberOfUsers += 1;
        currentNumberOfUsers += 1;
        SaveStatistics();
    }

    void Session_End(object sender, EventArgs e) 
    {
        currentNumberOfUsers -= 1;
    }

    public static int TotalNumberOfUsers
    {
        get
        {
            return totalNumberOfUsers;
        }
    }

    public static int CurrentNumberOfUsers
    {
        get
        {
            return currentNumberOfUsers;
        }
    } 
       
</script>

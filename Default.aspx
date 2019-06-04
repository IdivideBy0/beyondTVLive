<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width">
<style type="text/css">

body {
	background-color: #6666CC;
	height: 100%;
	width: 100%;
}

#page_header a {
	color: #fff;
	text-decoration: none;
}

#page_header a:hover {
	color: #e1e1e1;
}
.style1 {color: #99FFFF}

</style>
</head>
<body>
<div align="center"><img name="pic" src="header_snapStream_small_Admin.jpg" width="150" height="35" alt="">
</div>
<H3 align="center" class="style1">Mobile Television</H3>
    <form id="form1" runat="server" action="Default.aspx">
    <div id="controls" runat="server">
        <div>
            <asp:TextBox ID="BTVLicense" runat="server"></asp:TextBox>Enter your BTV License:
        </div>
        <div>
            <asp:TextBox ID="BTVusername" runat="server"></asp:TextBox>Enter your username:
        </div>
        <div>
            <asp:TextBox ID="BTVpassword" runat="server"></asp:TextBox>Enter your password:
        </div>
        <div>
            <asp:Button ID="submit" runat="server" Text="Submit" value="submitted" />
        </div>
    </div>
    <div>
        <asp:HyperLink ID="LiveTV" runat="server" Visible="false" NavigateUrl="MobileTVMain.aspx">Live TV</asp:HyperLink>
    </div>
</hr>
    <div>
        <asp:HyperLink ID="BTVWebAdmin" runat="server" Visible="false" NavigateUrl="/">BeyondTV Web Admin Page</asp:HyperLink>
    </div>
</hr>
     <div>
        <asp:HyperLink ID="Snapstream" runat="server" Visible="false" NavigateUrl="http://mobile.snapstream.net">Snapstream Mobile Site</asp:HyperLink>
    </div>

    </form>

    
</body>
</html>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string btvLicense, btvusername, btvpassword;

            btvLicense = BTVLicense.Text;
            btvusername = BTVusername.Text;
            btvpassword = BTVpassword.Text;

            //set cookie with entered values
            Response.Cookies["BTVCookie"]["BTVLicense"] = btvLicense;
            Response.Cookies["BTVCookie"]["BTVUsername"] = btvusername;
            Response.Cookies["BTVCookie"]["BTVPassword"] = btvpassword;

            LiveTV.Visible = true;
            BTVWebAdmin.Visible = true;
	    Snapstream.Visible = true;
	    
            // hide the form elements
            controls.Visible = false;
        }

        else
        {
            string cookie;
            
            try
            {
                cookie = Request.Cookies["BTVCookie"]["BTVLicense"].ToString();

                if (cookie != string.Empty)
                {
                    controls.Visible = false;
                    LiveTV.Visible = true;
                    BTVWebAdmin.Visible = true;
		    Snapstream.Visible = true;

                }

            }
            catch
            {
                return;
            }

        }

        
    }
}
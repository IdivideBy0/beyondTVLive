<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Runtime.InteropServices" %>
<%@ Import Namespace="SnapStream.BeyondTV" %>
<%@ Import Namespace="SnapStream.BeyondTV.WebServices" %>

<HTML id="_document" runat="server">
<HEAD>
<meta name="viewport" content="width=device-width">
<style type="text/css">

body {
	background-color: #6666CC;
}

#page_header a {
	color: #fff;
	text-decoration: none;
}

#page_header a:hover {
	color: #e1e1e1;
}

</style>
</HEAD>
<BODY>

<div style="text-align:center;">
<img name="pic" src="header_snapStream_small_Admin.jpg" width="150" height="35" alt="">
</div>

<script language="javascript">

function makeRequest(url) {
				var httpRequest;

				if (window.XMLHttpRequest) { // Mozilla, Safari, ...
					httpRequest = new XMLHttpRequest();
				} 
				else if (window.ActiveXObject) { // IE
					try {
						httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
					} 
					catch (e) {
						try {
							httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
						} 
						catch (e) {
						}
					}
				}

				if (!httpRequest) {
					return false;
				}

				httpRequest.open('GET', url, true);
				httpRequest.send(); 
				return false;
			}

function changeChannel(ChanNum) {
						
				strGuid = '<%=SessID.ToString%>';
				strChannel = ChanNum;
				strURL = 'http://' + location.host + '/mobile/MobileTVMain.aspx?mode=SetChannel&channel=';
				strURL += strChannel;
				strURL += '&guid=';
				strURL += strGuid;				
				
				makeRequest(strURL);
				document.getElementById('displayMsg').innerHTML = 'URL: ' + strURL;
				
			}

function keepAlive() {

				var dte = new Date();	
				strGuid = '<%=SessID.ToString%>';
				strURL = 'http://' + location.host + '/mobile/MobileTVMain.aspx?mode=KeepAlive&guid=';
				strURL += strGuid;
				strURL += '&time=' + dte.toString();

				makeRequest(strURL);
				document.getElementById('displayMsg').innerHTML = 'Session Runtime: ' + dte.toString();
				
				setTimeout( "keepAlive();", 15000 );
				
				}
								

setTimeout( "keepAlive();", 15000 );

</script>



<form id="Form1" method="post" runat="server">

<Script Language="VB" Runat="Server">
    
	Public Const GUID_NULL = "00000000-0000-0000-0000-000000000000"
    Dim StreamURL
    Dim SessID As Guid
    Dim ChannelLineup As String
    Dim CurrentChannel As String
    Dim PlayerMode As String
	Dim glChannel as string

    Function GetChannelList(ByVal Lineup As String, ByVal CurrentChannel As String)
        Dim P As Integer
        Dim P2 As Integer
        Dim P3 As Integer
        Dim ChkString As String
        Dim ChkString2 As String
        Dim ChannelName As String
        Dim ChannelNum As String
        Dim ChannelNum2 As String
        Dim ChannelList As String
        Dim ChannelsXML As Object
        Dim ChannelRec As Object
        Dim ChannelProp As Object
        Dim PropName As String
        Dim PropValue As String
        ChannelsXML = Server.CreateObject("MSXML.DOMDocument")
        ChannelsXML.LoadXML(Lineup)
        ChannelList = ""
        For Each ChannelRec In ChannelsXML.documentElement.childNodes
            If ChannelRec.nodeName = "Channel" Then
                For Each ChannelProp In ChannelRec.childNodes
                    PropName = ChannelProp.childNodes(0).Text
                    PropValue = ChannelProp.childNodes(1).Text
                    Select Case PropName
                        Case "StationName"
                            ChannelName = PropValue
                        Case "TMSChannel"
                            ChannelNum = PropValue
                        Case "UniqueChannelID"
                            ChannelNum2 = PropValue
				glChannel = ChannelNum2
                        Case Else
                            'Response.Write(   & " = " & ChannelProp.childNodes(1).Text & "<BR>")
                    End Select
                Next
                ChannelList = ChannelList & "<option value=""" & ChannelNum2 & """"
                If CurrentChannel = ChannelNum2 Then
                    ChannelList = ChannelList & " SELECTED"
                End If
                ChannelList = ChannelList & ">" & ChannelName & " (" & ChannelNum & ")</option>"
            End If
        Next
        ChannelProp = Nothing
        ChannelRec = Nothing
        ChannelsXML = Nothing
        GetChannelList = ChannelList
    End Function

    Function GetHost()
        Dim HostName As String
        Dim P As Long
        HostName = Request.ServerVariables("HTTP_HOST")
        P = InStr(HostName, ":")
        If P <> 0 Then
            HostName = Left(HostName, P - 1)
        End If
        GetHost = HostName
    End Function

    Sub Page_load(ByVal Sender As Object, ByVal E As EventArgs)
   
        Dim ExistingGUID As Guid
        Dim LiveTV As New BTVLiveTVManager
        Dim BTVSet As New BTVSettings
	'Dim TVGuide as New BTVGuideData
        Dim Sessions() As PVSPropertyBag          
        
	Dim networkLicense as string
        Dim username as string
        Dim password as string

	If (Request.Cookies("BTVCookie") IsNot Nothing) Then
    		If (Request.Cookies("BTVCookie")("BTVLicense") IsNot Nothing) Then
        	networkLicense = Request.Cookies("BTVCookie")("BTVLicense")
    		End If
	End If

	If (Request.Cookies("BTVCookie") IsNot Nothing) Then
    		If (Request.Cookies("BTVCookie")("BTVUsername") IsNot Nothing) Then
        	username = Request.Cookies("BTVCookie")("BTVUsername")
    		End If
	End If

	If (Request.Cookies("BTVCookie") IsNot Nothing) Then
    		If (Request.Cookies("BTVCookie")("BTVPassword") IsNot Nothing) Then
        	password = Request.Cookies("BTVCookie")("BTVPassword")
    		End If
	End If
	
	
        
        Dim lm As New BTVLicenseManager
        
        Dim pvspb As PVSPropertyBag = lm.Logon(networkLicense, username, password)
        Dim strAuthTicket As String = ""
        For Each pvp As PVSProperty In pvspb.Properties
            If pvp.Name.Equals("AuthTicket") Then
                'gets ticket so we can run all the other commands 
                strAuthTicket = pvp.Value
            End If
        Next
        


        
        Dim FirstSession
        Dim Prop As PVSProperty
        Dim SessNum As Integer
        Dim strGUID As String
        Dim Mode As String
        Dim Channel As String
        Mode = Request.QueryString("Mode")
        strGUID = Request.QueryString("GUID")
        Channel = Request.QueryString("Channel")
        PlayerMode = Request.QueryString("PlayerMode")
        If PlayerMode = "" Then
            PlayerMode = "Link"
        End If


        Select Case Mode
            Case "Existing"
                ExistingGUID = New Guid(strGUID)
                SessID = LiveTV.ExistingWebSession(strAuthTicket, ExistingGUID)
                CurrentChannel = LiveTV.GetChannel(strAuthTicket, SessID)
                ChannelLineup = BTVSet.GetUnifiedLineup(strAuthTicket)
                _document.Visible = True

            Case "KeepAlive"
                _document.Visible = False
                ExistingGUID = New Guid(strGUID)
                LiveTV.KeepAlive(strAuthTicket, ExistingGUID)
                CurrentChannel = LiveTV.GetChannel(strAuthTicket, ExistingGUID)
                ChannelLineup = BTVSet.GetUnifiedLineup(strAuthTicket)	
                Response.Write("Time:" & Request.QueryString("time"))

            Case "SetChannel"
                _document.Visible = False
                ExistingGUID = New Guid(strGUID)
                CurrentChannel = LiveTV.GetChannel(strAuthTicket, ExistingGUID)
                ChannelLineup = BTVSet.GetUnifiedLineup(strAuthTicket)
                LiveTV.SetChannel(strAuthTicket, ExistingGUID, Channel)

            Case Else
                _document.Visible = True
                SessID = LiveTV.NewWebSession(strAuthTicket)
                If SessID.ToString = GUID_NULL Then
                    StreamLinkDiv.Visible = False
                    ChannelNumDiv.Visible = False
                    Response.Write("Choose a session<BR>")
                    Sessions = LiveTV.GetSessions(strAuthTicket)
                    For SessNum = 0 To UBound(Sessions)
                        For Each Prop In Sessions(SessNum).Properties
                            If Prop.Name = "RecorderGUID" Then
                                Response.Write("<A HREF=""MobileTVMain.aspx?mode=Existing&guid=" & Prop.Value & "&PlayerMode=" & PlayerMode & """>" & Prop.Value & "</A><BR>")
                            End If
                        Next
                    Next
                Else
                    CurrentChannel = LiveTV.GetChannel(strAuthTicket, SessID)
                    ChannelLineup = BTVSet.GetUnifiedLineup(strAuthTicket)
                    _document.Visible = True
                End If
        End Select
        
		StreamURL = "mms://" & GetHost() & ":8080/*"
        
		Prop = Nothing
        Sessions = Nothing
        LiveTV = Nothing
        BTVSet = Nothing
		lm = Nothing
		
    End Sub
</Script>

<div id="StreamLinkDiv" runat="Server"> <div id="page_header"><A id=StreamLink HREF="<%= StreamURL %>">Play Stream</A> -- <a href="default.aspx" target="_top"> Go Back</a></div><BR></div>
<div id="ChannelNumDiv" runat="server"><select id="ChannelNum" name="ChannelNum" ><%= GetChannelList(ChannelLineup,CurrentChannel) %></select>
<input name="Go" type="button" id="Go" value="Go" onClick="changeChannel(Form1.ChannelNum.value)">
</div>

<div id="displayMsg">
    
</div>

</form>
</BODY>
</HTML>


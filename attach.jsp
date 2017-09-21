<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<jsp:useBean id="sessionBean" scope="session" class="com.ngenx.edms.SessionBean"></jsp:useBean>
<jsp:useBean id="documentsBean" scope="session" class="com.ngenx.edms.Documents.DocumentsBean"></jsp:useBean>
<jsp:useBean id="pooledBean" scope="session" class="com.ngenx.edms.Pool.PooledBean"></jsp:useBean>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%
if(!sessionBean.getIsLoggedIn()){%><jsp:forward page="../profiles/please_login.jsp" /><%}
String loggedInUserSerial = sessionBean.getLoggedInUserID();

ResultSet drawerFoldersRs = null;

String action = "";
if(request.getParameter("action") !=null && !request.getParameter("action").equals("")){
action = request.getParameter("action");
}

String registryPoolSerial = "";
if(request.getParameter("registryPoolSerial") !=null && !request.getParameter("registryPoolSerial").equals("")){
registryPoolSerial = request.getParameter("registryPoolSerial");
}
%>
        <fieldset>
            <legend>Documents Uploads</legend>
            <!--<input type="button" name="button" id="button" value="Button" onClick="javascript:loadPageInDiv('/resources/dragdrop/','files.jsp?','fileviewdiv');">-->
            <div>
              <label for="fileselect">Files to upload:</label>
              <table class="dragtable">
              <tr class="dragtr"><td class="dragtd"><input type="file" id="fileselect" name="fileselect[]" multiple /></td><td class="dragtd"><button class="dragbtn" onClick="resetOnClick();">clear field</button></td><td class="dragtd"><button class="dragbtn" onClick="deleteAll();">Delete all</button></td></tr>
              </table>
                <table class="dragtable" id="dragdrop">
                <tr class="dragtr">
                <td class="dragtd" width="70%">
                    <div id="filedrag"><h3 align="center">Drop Files Here</h3><br>   
                        <table class="dragtable" id="messages"></table>
                    </div>
                    </td>
                    <td class="dragtd" width="30%">
                    <div id="fileviewdiv">
                      <jsp:include page="files.jsp" flush="true"></jsp:include>
                    </div>
                    </td>
                    </tr>
                </table>    
            </div>
        </fieldset>
    <div>        
        <div id="uploadFileItem" class="center">
            <!--<legend> Uploaded Items </legend>-->
            <div id="progress"></div>
        </div>
    </div>
    <div>
        <table id="messages">

        </table>
    </div>

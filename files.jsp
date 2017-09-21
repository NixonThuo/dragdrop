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
    if (!sessionBean.getIsLoggedIn()) {%><jsp:forward page="../profiles/please_login.jsp" /><%}
    String loggedInUserSerial = sessionBean.getLoggedInUserID();

    ResultSet drawerFoldersRs = null;

    String action = "";
    if (request.getParameter("action") != null && !request.getParameter("action").equals("")) {
        action = request.getParameter("action");
    }
    //System.out.println(sessionBean.getUploadedFilesLists());
    //out.print(sessionBean.getUploadedFilesList());	
/*
for (int i = 0; i < sessionBean.getUploadedFilesList().size(); i++) {
out.println(sessionBean.getUploadedFilesListFileName(i));
out.println(sessionBean.getUploadedFilesListFileMimeType(i));
out.println(sessionBean.getUploadedFilesListFileSize(i));
}
     */
    Integer listSize = sessionBean.getUploadedFilesList().size();
    String units = "";
%> 
<h3 align="center">Uploaded Files</h3>
    <table class="dragtable" id="datafiles" style="background-color: rgb(243, 243, 243);">
        <% for (int i = 0; i < sessionBean.getUploadedFilesList().size(); i++) {
        %><tr class="dragtr"><td class="dragtd"><%=sessionBean.getUploadedFilesListFileName(i)%></td><td class="dragtd"><% if (sessionBean.getUploadedFilesListFileSize(i) > 1024 * 1024) {%><%=(sessionBean.getUploadedFilesListFileSize(i)) / (1024 * 1024)%><%} else {%><%=(sessionBean.getUploadedFilesListFileSize(i)) / (1024)%><%}%><%if (sessionBean.getUploadedFilesListFileSize(i) > 1024 * 1024) {
                units = "MB";
            } else {
                units = "KB";
            }%>  <%=units%></td><td class="dragtd"><button class="dragbtn" value="<%=i%>" onClick="postOnClick(this.value);">Delete</button></td></tr>
                <%}%>	    
    </table>



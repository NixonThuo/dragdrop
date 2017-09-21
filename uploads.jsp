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

System.out.println(sessionBean.UPLOADED_FILES_LIST);
%> 


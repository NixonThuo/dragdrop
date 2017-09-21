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
    System.out.println("imefika");

    if (!sessionBean.getIsLoggedIn()) {%><jsp:forward page="../profiles/please_login.jsp" /><%}
        String loggedInUserSerial = sessionBean.getLoggedInUserID();

        ResultSet drawerFoldersRs = null;
        System.out.println("Tuko locked" + loggedInUserSerial);

        String action = "";
        if (request.getParameter("action") != null && !request.getParameter("action").equals("")) {
            action = request.getParameter("action");
        }

        System.out.println("Tunataka ku " + action);

        String indexPosition = "";
        if (request.getParameter("indexPosition") != null && !request.getParameter("indexPosition").equals("")) {
            indexPosition = request.getParameter("indexPosition");
        }

        System.out.println(indexPosition);

        if (action.equals("delete")) {

            sessionBean.removeUploadedFileFromList(Integer.parseInt(indexPosition));
            System.out.println("delete at index");
        }

        if (action.equals("deleteall")) {
            sessionBean.clearUploadedFilesList();
            System.out.println("deleted all");
        }
%> 



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
		
	String fileTitle = "";
	String fileMimeType = "";
	String fileObjectName = "";
	Long fileSize = 0L;
	String notes = "";
	
	try{
		  if(action.equals("save") || action.equals("update")){
			  out.println("Wants to save");
				 MultipartParser multPart = new MultipartParser(request, 1024 * 1024 * 1024);
				 ByteArrayOutputStream baos =new ByteArrayOutputStream();				 
				 com.oreilly.servlet.multipart.Part part = null;				
				 while ((part = multPart.readNextPart()) != null) {					     	     
					 if(part.isFile()){						  
						    FilePart filePart = (FilePart) part;
						    fileMimeType = filePart.getContentType();
							fileObjectName = filePart.getFileName();
							Integer size = sessionBean.getUploadedFilesListSize();
						    if (!fileObjectName.equals("")) {					
							   fileSize = filePart.writeTo(baos);
						    }
					  }else{
						  ParamPart paramPart = (ParamPart) part;
                          String paramName = part.getName();
                          String value = paramPart.getStringValue();
					  }
				 }//end of while
				 sessionBean.addUploadedFileToList(baos.toByteArray(), fileObjectName, fileMimeType);
		   }//end if action
	 }catch(Exception sqle){
		 out.print("Shinda mahali "+sqle.getMessage());
	 }	
%> 
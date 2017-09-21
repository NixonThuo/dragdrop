 <%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
            <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <link rel="stylesheet" type="text/css" media="all" href="styles.css" />
                    <title>Untitled Document</title>
                    <jsp:useBean id="sessionBean" scope="session" class="com.ngenx.edms.SessionBean">
                    </jsp:useBean>
                    <jsp:useBean id="workflowBean" scope="session" class="com.ngenx.edms.Workflow.WorkflowBean">
                    </jsp:useBean>
                    <jsp:useBean id="systemPropertiesBean" scope="application" class="com.ngenx.edms.System.SystemPropertiesBean">
                    </jsp:useBean>
                    <%@ page import="java.io.*"%>
                    <%@ page import="java.sql.*"%>
                    <%@ page import="java.text.*"%>
                    <%@ page import="com.oreilly.servlet.*"%>
                    <%@ page import="com.oreilly.servlet.multipart.*"%>
                    <%

                        if (!sessionBean.getIsLoggedIn()) {%>
                    <jsp:forward page="../profiles/please_login.jsp" />
                    <%}
                        String loggedInUserSerial = sessionBean.getLoggedInUserID();

                        ResultSet workflowDocumentStageRs = null;

                        String activeWorkflowSerial = workflowBean.getActiveWorkflowSerial();
                        String activeWorkflowName = workflowBean.getActiveWorkflowName();
                        String activeWorkflowStageSerial = workflowBean.getActiveWorkflowStageSerial();
                        String activeWorkflowInitials = workflowBean.getActiveWorkflowInitials();

                        String action = "add";
                        /**
                         * if(request.getParameter("action") !=null &&
                         * !request.getParameter("action").equals("")){ action =
                         * request.getParameter("action"); }
                         *
                         */

                        String documentSerial = "2";
                        /**
                         * if(request.getParameter("documentSerial") !=null &&
                         * !request.getParameter("documentSerial").equals("")){
                         * documentSerial = request.getParameter("documentSerial"); }
                         *
                         */

                        String documentTypeSerial = "3";
                        /**
                         * if(request.getParameter("documentTypeSerial") !=null &&
                         * !request.getParameter("documentTypeSerial").equals("")){
                         * documentTypeSerial = request.getParameter("documentTypeSerial");
                         * }
                         *
                         */

                        String attachmentSerial = "5";
                        /**
                         * if(request.getParameter("attachmentSerial") !=null &&
                         * !request.getParameter("attachmentSerial").equals("")){
                         * attachmentSerial = request.getParameter("attachmentSerial"); }
                         *
                         */

                        String attachmentTitle = "";
                        String attachmentSubject = "";
                        String fileReference = "";
                        String workflowFolderName = "";
                        String workflowFolderSerial = "";
                        String keywords = "";
                        String fileMimeType = "";
                        String fileName = "";
                        String notes = "";

                        try {
                            if (action.equals("save") || action.equals("update")) {
                                MultipartParser multPart = new MultipartParser(request, 1024 * 1024 * 100);
                                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                String filename = "";
                                com.oreilly.servlet.multipart.Part part = null;
                                Long fileSize = 0L;
                                while ((part = multPart.readNextPart()) != null) {
                                    if (part.isParam()) {
                                        ParamPart paramPart = (ParamPart) part;
                                        String paramName = part.getName();
                                        String value = paramPart.getStringValue();
                                        if (paramName.equals("attachmentTitle")) {
                                            attachmentTitle = value;
                                        } else if (paramName.equals("attachmentSubject")) {
                                            attachmentSubject = value;
                                        } else if (paramName.equals("fileReference")) {
                                            fileReference = value;
                                        } else if (paramName.equals("workflowFolderSerial")) {
                                            workflowFolderSerial = value;
                                        } else if (paramName.equals("notes")) {
                                            notes = value;
                                        } else if (paramName.equals("keywords")) {
                                            keywords = value;
                                        }
                                    } else if (part.isFile()) {
                                        FilePart filePart = (FilePart) part;
                                        fileMimeType = filePart.getContentType();
                                        fileName = filePart.getFileName();
                                        if (fileName != null && !fileName.equals("")) {
                                            fileSize = filePart.writeTo(baos);
                                        }
                                    }//end of if
                                }//end of while
                                if (action.equals("save")) {
                                    String colNames = "workflow_serial, wkf_" + activeWorkflowInitials + "_document_serial, attachment_title, keywords, notes, addedby_user_serial,wkf_" + activeWorkflowInitials + "_stage_serial,subject,reference_number, wfms_workflow_folder_serial, wfms_workflow_document_type_serial";
                                    String colValues = "" + activeWorkflowSerial + "," + documentSerial + ",'" + attachmentTitle + "','" + keywords + "','" + notes + "'," + loggedInUserSerial + "," + activeWorkflowStageSerial + ",'" + attachmentSubject + "','" + fileReference + "'," + workflowFolderSerial + "," + documentTypeSerial + "";
                                    String SQLstr = "INSERT INTO wkf_" + activeWorkflowInitials + "_attachments (" + colNames + ") VALUES (" + colValues + ")";
                                    out.println(SQLstr);
                                    if (sessionBean.executeDBQuery(SQLstr)) {
                                        SQLstr = "Select Max(a.wkf_" + activeWorkflowInitials + "_attachment_serial) As attachment_serial"
                                                + " From wkf_" + activeWorkflowInitials + "_attachments a"
                                                + " Where a.workflow_serial = " + activeWorkflowSerial + " And a.addedby_user_serial = " + loggedInUserSerial + "";
                                        ResultSet rs = sessionBean.getDataResultSet(SQLstr);
                                        if (rs.next()) {
                                            attachmentSerial = rs.getString("attachment_serial");
                                            String returnFileName = workflowBean.uploadNewFileToWorkflowFolder(activeWorkflowSerial, documentSerial, attachmentSerial, fileName, baos);
                                            SQLstr = "UPDATE wkf_" + activeWorkflowInitials + "_attachments SET attachment_filename='" + returnFileName + "', attachment_mimetype='" + fileMimeType + "' Where wkf_" + activeWorkflowInitials + "_attachment_serial = " + attachmentSerial;
                                            sessionBean.executeDBQuery(SQLstr);
                                            colNames = "wkf_" + activeWorkflowInitials + "_document_serial, workflow_stage_serial, workflow_serial,actionby_system_user_serial, action_type,  comments";
                                            colValues = "" + documentSerial + ", " + activeWorkflowStageSerial + ", " + activeWorkflowSerial + "," + loggedInUserSerial + ", 'Added Attachment','" + fileName + "'";
                                            SQLstr = "INSERT INTO wkf_" + activeWorkflowInitials + "_stage_actions (" + colNames + ") VALUES (" + colValues + ")";
                                            out.print(SQLstr);
                                            sessionBean.executeDBQuery(SQLstr);
                                        }
                    %>
                    <script language="javascript" type="text/javascript">
                        alert("Adding an attachment was successful.");
                        window.close();
                    </script>
                    <%
                        }
                    } else if (action.equals("update") && fileSize == 0) {
                        String colValues = "attachment_title='" + attachmentTitle + "', keywords='" + keywords + "', notes=='" + notes + "',subject='" + attachmentSubject + "', reference_number='" + fileReference + "'";
                        String SQLstr = "UPDATE wkf_" + activeWorkflowInitials + "_attachments SET " + colValues + " WHERE wkf_" + activeWorkflowInitials + "_attachment_serial = " + attachmentSerial;
                        //out.print(SQLstr);
                        sessionBean.executeDBQuery(SQLstr);
                        String colNames = "wkf_" + activeWorkflowInitials + "_document_serial, workflow_stage_serial, workflow_serial,actionby_system_user_serial, action_type,  comments";
                        colValues = "" + documentSerial + ", " + activeWorkflowStageSerial + ", " + activeWorkflowSerial + "," + loggedInUserSerial + ", 'Update Attachment','" + fileName + "'";
                        SQLstr = "INSERT INTO wkf_" + activeWorkflowInitials + "_stage_actions (" + colNames + ") VALUES (" + colValues + ")";
                        sessionBean.executeDBQuery(SQLstr);
                    %>
                    <script language="javascript" type="text/javascript">
                        alert("Updating attachment was successful.");
                        window.close();
                    </script>
                    <%
                    } else if (action.equals("update") && fileSize >= 0) {
                        String colNames = "attachment_mimetype,attachment_filename, workflow_serial, wkf_" + activeWorkflowInitials + "_document_serial, attachment_title, keywords, notes, addedby_user_serial,revision_number,revisedfrom_document_serial";
                        String colValues = "'" + fileMimeType + "','" + fileName + "'," + activeWorkflowSerial + "," + documentSerial + ",'" + attachmentTitle + "','" + keywords + "','" + notes + "'," + loggedInUserSerial + ",'1.0.1'," + attachmentSerial + "";
                        String SQLstr = "INSERT INTO wkf_" + activeWorkflowInitials + "_attachments (" + colNames + ") VALUES (" + colValues + ")";
                        //out.print(SQLstr);
                        if (sessionBean.executeDBQuery(SQLstr)) {
                            ResultSet rs = sessionBean.getDataResultSet("SELECT max(wkf_" + activeWorkflowInitials + "_attachment_serial) as max_serial FROM wkf_" + activeWorkflowInitials + "_attachments");
                            if (rs.next()) {
                                PreparedStatement psmt = sessionBean.getDBPreparedStatement("INSERT INTO wkf_" + activeWorkflowInitials + "_attachment_objects (attachment,wkf_" + activeWorkflowInitials + "_attachment_serial) VALUES(?," + rs.getString("max_serial") + ")");
                                byte imagebytes[] = new byte[fileSize.intValue()];
                                imagebytes = baos.toByteArray();
                                psmt.setBytes(1, imagebytes);
                                psmt.execute();
                            }
                            colNames = "wkf_" + activeWorkflowInitials + "_document_serial, workflow_stage_serial, workflow_serial,actionby_system_user_serial, action_type,  comments";
                            colValues = "" + documentSerial + ", " + activeWorkflowStageSerial + ", " + activeWorkflowSerial + "," + loggedInUserSerial + ", 'Added Attachment','" + fileName + "'";
                            SQLstr = "INSERT INTO wkf_" + activeWorkflowInitials + "_stage_actions (" + colNames + ") VALUES (" + colValues + ")";
                            //out.print(SQLstr);
                            sessionBean.executeDBQuery(SQLstr);
                        }

                    %>
                    <script language="javascript" type="text/javascript">
                        alert("Updating attachment was successful.");
                        window.close();
                    </script>
                    <%                                                      }
                            } else if (action.equals("edit") || action.equals("view")) {
                                String SQLstr = "Select da.attachment_title, da.keywords, da.notes, da.attachment_mimetype,  da.revision_number, wf.folder_name, da.wfms_workflow_folder_serial"
                                        + " From wkf_" + activeWorkflowInitials + "_attachments da Inner Join"
                                        + "      wfms_workflow_folders wf On da.wfms_workflow_folder_serial =  wf.wfms_workflow_folder_serial"
                                        + " Where da.wkf_" + activeWorkflowInitials + "_attachment_serial = 105 And da.wkf_" + activeWorkflowInitials + "_document_serial = " + documentSerial;
                                out.println(SQLstr);
                                ResultSet worflowDocumentAttachmentsRs = sessionBean.getDataResultSet(SQLstr);

                            }//end of if action
                        } catch (SQLException sqle) {
                            out.print(sqle.getMessage());
                        }

                        if (action.equals("add")) {
                            action = "save";
                        } else if (action.equals("edit")) {
                            action = "update";
                        }

                    %>
                    <jsp:include page="../../resources/details_form/head.jsp" flush="true" /></head>
                <body>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr class="MainTableHeading">
                            <td height="24">Attachment Details </td>
                        </tr>
                        <tr>
                            <td><form action="/workflow/execution/workflow_document_attachment_details.jsp?action=<%=action%>&amp;status=ready&amp;documentSerial=<%=documentSerial%>&amp;attachmentSerial=<%=attachmentSerial%>&amp;documentTypeSerial=<%=documentTypeSerial%>" method="post" enctype="multipart/form-data" name="attachmentForm" target="_self" id="attachmentForm">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                        <tr>
                                            <td width="26%">&nbsp;</td>
                                            <td width="67%">&nbsp;</td>
                                        </tr>
                                                                                <tr>
                                            <td colspan="2">  <fieldset>
                                                    <legend>Documents Uploads</legend>

                                                    <div>
                                                        <label for="fileselect">Files to upload:</label>
                                                        <input type="file" id="fileselect" name="fileselect[]" multiple />
                                                        <div id="filedrag">Drop Files Here</div>
                                                    </div>

                                                </fieldset></td>
                                        </tr>
                                                                                <tr>
                                            <td colspan="2">                    <div>
                        <p>Uploaded Files</p>
                        <table id="messages">

                        </table>
                    </div></td>
                                        </tr>
                                        <tr>
                                            <td>Title</td>
                                            <td><input name="attachmentTitle" type="text" class="inputEditTextBox" id="attachmentTitle" value="<%=attachmentTitle%>" size="40" /></td>
                                        </tr>
                                        <tr>
                                            <td>Subject</td>
                                            <td><input name="attachmentSubject" type="text" class="inputEditTextBox" id="attachmentSubject" value="<%=attachmentSubject%>" size="40" /></td>
                                        </tr>
                                        <tr>
                                            <td>File Reference</td>
                                            <td><input name="fileReference" type="text" class="inputEditTextBox" id="fileReference" value="<%=fileReference%>" size="40" /></td>
                                        </tr>
                                        <% if (action.equals("update")) { %>
                                        <tr>
                                            <td>Revised Document</td>
                                            <td><input name="attachmentFile" type="file" id="attachmentFile" size="40" /></td>
                                        </tr>
                                        <% } else if (action.equals("view")) { %>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <% } else { %>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <% }%>
                                        <tr>
                                            <td>workflow Folder </td>
                                            <td><input name="workflowFolderName" class="inputGeneralTextBox" type="text" disabled="disabled" id="workflowFolderName" value="<%=workflowFolderName%>" size="39"/>
                                                <input name="workflowFolderSerial" type="hidden" id="workflowFolderSerial" value="<%=workflowFolderSerial%>"/>
                                                <input name="workflowFolderButton" type="button" id="workflowFolderButton" value="::" class="ButtonGeneral" onclick="javascript:displayLookUpWindow('workflowFolderName', 'workflowFolderSerial', 'Select workflow Folder', 'Select wf.wfms_workflow_folder_serial, wf.folder_name From wfms_workflow_folders wf');" /></td>
                                        </tr>
                                        <tr>
                                            <td>Description/Notes</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><textarea name="textareaNotes" id="textareaNotes" class="iEdit" style="width:99%;height:104px;" <% if (action.equals("view")) {
                                                    out.print(" readonly=\"readonly\" ");
                                                }%>><%=notes%></textarea>
                                                <input type="hidden" name="notes" id="notes" /></td>
                                        </tr>
                                        <tr>
                                            <td>Keywords</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><textarea name="keywords" rows="2" id="keywords" style="width:95%;"><%=keywords%></textarea></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><button class="btn info" name="submit" type="submit" value="Save Attachment">Upload Files</button>
                                    <input name="Reset" type="reset" class="ButtonCancel" value="Cancel Details" onclick="javascript:window.close();"/></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                    </table>
                                </form></td>
                        </tr>
                    </table>
                    <jsp:include page="../../resources/details_form/foot.jsp" flush="true" />
                    <script src="filedrag.js"></script>                      
        </body>
    </html>
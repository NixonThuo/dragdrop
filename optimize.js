// JavaScript Document
// getElementById
function $id(id) {
    return document.getElementById(id);
}

// file drag hover
function FileDragHover(e) {
    e.stopPropagation();
    e.preventDefault();
    e.target.className = (e.type == "dragover" ? "hover" : "");
}


// file selection
function FileSelectHandler(e) {

    // cancel event and hover styling
    FileDragHover(e);

    // fetch FileList object
    var files = e.target.files || e.dataTransfer.files;

    // process all File objects
    for (var i = 0, f; f = files[i]; i++) {
        UploadFile(f);
    }

}



// output file information
function ParseFile(file) {

    var iconpath = "";
    var size = 0;
    var units = "";

    if (file.type == "application/pdf") {
        iconpath = "<img src='resources/dragdrop/pdf.png' style='width:50px;height:50px;'>";
    } else {
        iconpath = "File Information:";
    }

    if (file.size > 1048576) {
        size = file.size / 1024 / 1024;
        units = "MB";
    } else {
        size = file.size / 1024;
        units = "KB";
    }


    return  "<td class='dragtd'>" + iconpath + "</td><td class='dragtd'>" + file.name + "</td><td class='dragtd'>" + file.type + "<td class='dragtd'>" + size.toFixed(2) + "" + units + "</td>";
}


// upload JPEG files
function UploadFile(file) {

    // following line is not necessary: prevents running on SitePoint servers
    if (location.host.indexOf("sitepointstatic") >= 0)
        return

    var xhr = new XMLHttpRequest();
    if (xhr.upload) {

        // create progress bar
        var o = $id("messages");
        var k = $id("progress");
        var step = k.appendChild(document.createElement("z"));
        var content = o.appendChild(document.createElement("tr"));
        var progress = k.appendChild(document.createElement("p"));
        progress.appendChild(document.createTextNode("Waiting to upload"));
        // progress bar
        xhr.upload.addEventListener("progress",
                function (e) {
                    var pc = parseInt(e.loaded / e.total * 100);
                    progress.style.width = pc + "%";
                    progress.innerHTML = pc + "% " + file.name;
                    if (pc == 100) {
                        content.innerHTML = ParseFile(file);
                        k.removeChild(progress);
                    } else {

                    }
                },
                false
                );

        // file received/failed
        xhr.onreadystatechange = function (e) {
            if (xhr.readyState == 4) {
                progress.className = (xhr.status == 200 ? "success" : "failure");
            }
        };
        //make multipart
        var formData = new FormData();
        formData.append("thefile", file);

        // start upload
        xhr.open('POST', '/resources/dragdrop/upload.jsp?action=save', true);
        //xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            try {
                if (xhr.readyState == 4) {
                    if (xhr.status == 200) {
                        var respText = xhr.responseText.replace(/^\s+|\s+$/g, "");
                        loadPageInDiv('resources/dragdrop', 'files.jsp', 'fileviewdiv')
                    } else {
                        alert("error hatujui");
                    }
                }
            } catch (e) {
                alert(e);
            }
        };
        xhr.send(formData);
        ParseFile(file);
    }

}


// initialize
function Init(id) {

    var fileselect = $id(id),
            filedrag = $id(id),
            submitbutton = $id(id);

    // file select
    fileselect.addEventListener("change", FileSelectHandler, false);

    // is XHR2 available?
    var xhr = new XMLHttpRequest();
    if (xhr.upload) {

        // file drop
        filedrag.addEventListener("dragover", FileDragHover, false);
        filedrag.addEventListener("dragleave", FileDragHover, false);
        filedrag.addEventListener("drop", FileSelectHandler, false);
        filedrag.style.display = "block";

        // remove submit button
        submitbutton.style.display = "none";
    }

}


function startDrop(id)
{
    // call initialization file
    if (window.File && window.FileList && window.FileReader) {
        Init(id);
        UploadFile(file);
    }
}
function postOnClick(i)
{
    var http = new XMLHttpRequest();

    alert("are you sure you want to delete file at index position " + i);

    var action = "delete";

    http.open("POST", "/resources/dragdrop/delete.jsp?action=" + action + "&indexPosition=" + i, true);
    //http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //http.setRequestHeader("Content-length", params.length);
    //http.setRequestHeader("Connection", "close");

    http.onreadystatechange = function () {
        if (http.readyState == 4 && http.status == 200) {
            alert("Deleted");
            loadPageInDiv('resources/dragdrop', 'files.jsp', 'fileviewdiv')
        }
    }

    http.send();
}

function refreshOnClick()
{
    loadPageInDiv('resources/dragdrop', 'files.jsp', 'fileviewdiv')
}

function resetOnClick()
{
    var myNode = document.getElementById("messages");
    while (myNode.firstChild) {
        myNode.removeChild(myNode.firstChild);
    }
}

function deleteAll()
{
    var http = new XMLHttpRequest();

    alert("are you sure you want to delete file all files");

    var action = "deleteall";

    http.open("POST", "/resources/dragdrop/delete.jsp?action=" + action, true);
    //http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //http.setRequestHeader("Content-length", params.length);
    //http.setRequestHeader("Connection", "close");

    http.onreadystatechange = function () {
        if (http.readyState == 4 && http.status == 200) {
            alert("Deleted");
            loadPageInDiv('resources/dragdrop', 'files.jsp', 'fileviewdiv')
        }
    }

    http.send();
} 
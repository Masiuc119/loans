<#macro page>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Loans</title>
    <link rel="stylesheet" href="/static/style.css">

    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
    <script src='https://www.google.com/recaptcha/api.js'></script>
</head>
<body>
<#include "navbar.ftl">
<div class="container mt-5">
<#nested>
</div>
<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
<script>
    function upload(file) {
        if (!file || !file.type.match(/image.*/)) return;
        var fd = new FormData();
        fd.append("image", file);
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "https://api.imageban.ru/v1");
        xhr.onload = function() {
            document.querySelector("#customFile_input").value = JSON.parse(xhr.responseText).data.link;
        }
        xhr.setRequestHeader('Authorization', 'TOKEN CrtD5aHKfZwtcVqjzBPP');
        xhr.send(fd);
    }
</script>
</body>
</html>
</#macro>
<#macro imgUploadForm>
    <div class="form-group">
        <div class="custom-file">
            <input type="file" name="custom-file-input" class="custom-file-input" id="customFile" onchange="upload(this.files[0])" accept="image/*">
            <label class="custom-file-label" for="customFile">Выберите файл...</label>
            <input type="hidden" name="file" id="customFile_input">
        </div>
    </div>
</#macro>
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
<script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
<script src="/static/script.js"></script>
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
<#macro dealForm>
    <div class="form-group mt-3">
        <form method="post" enctype="multipart/form-data">
            <label for="periodStr">Срок займа </label>
            <b><u>
                    <output for="periodStr" id="period_value"><#if !deals??>${deal.period}<#else>30</#if></output>
                </u></b>
            <label for="periodStr"> дней.</label>
            <input type="range" class="custom-range" min="1" max="100" value="<#if !deals??>${deal.period}<#else>30</#if>" id="periodStr" name="period"
                   oninput="periodUpdate(value)">
            <br/><br/>
            <label for="amountStr">Желаемая сумма </label>
            <b><u>
                    <output for="amountStr" id="amount_value"><#if !deals??>${deal.amount}<#else>100</#if></output>
                </u></b>
            <label for="amountStr"> рублей.</label>
            <input type="range" class="custom-range" min="10" max="3000" value="<#if !deals??>${deal.amount}<#else>100</#if>" id="amountStr" name="amount"
                   oninput="amountUpdate(value)">
            <br/><br/>
            <label for="percentStr">Оплата за пользование не более </label>
            <b><u>
                    <output for="percentStr" id="percent_value"><#if !deals??>${deal.percent}<#else>20</#if></output>
                </u></b>
            <label for="percentStr"> % в 30 дней.</label>
            <input type="range" class="custom-range" min="1" max="100" value="<#if !deals??>${deal.percent}<#else>20</#if>" step="0.1" id="percentStr"
                   name="percent"
                   oninput="percentUpdate(value)">
            <br/>
            <small class="form-text text-muted">
                Ориентировочно полная сумма к погашению составит
                <output for="percentStr amountStr periodStr" id="summ_value">0</output>
                рублей.
            </small>
            <br/>
            <div class="form-group">
                <input type="text" class="form-control ${(textError??)?string('is-invalid', '')}"
                       value="<#if !deals??>${deal.comment}</#if>" name="comment"
                       placeholder="Ваш комментарий..."/>
                <#if textError??>
                    <div class="invalid-feedback">
                        ${textError}
                    </div>
                </#if>
            </div>
            <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample1" role="button"
               aria-expanded="false" aria-controls="collapseExample1">
                Добавить фото товара залогового товара...
            </a>
            <br/>
            <div class="collapse <#if message??>show</#if>" id="collapseExample1">
                <@c.imgUploadForm></@c.imgUploadForm>
            </div>
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <#if !deals??><input type="hidden" name="id" value="${deal.id}"/></#if>
            <div class="form-group">
                <button type="submit" class="btn btn-primary"><#if !deals??>Сохранить<#else>Добавить</#if></button>
            </div>
        </form>
    </div>
</#macro>
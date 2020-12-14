<#macro page>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Loans</title>
        <link rel="stylesheet" href="/static/css/slicknav.css">
        <link rel="stylesheet" href="/static/css/style_manual.css">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="/static/css/bootstrap.min.css">
        <link rel="stylesheet" href="/static/css/style.css">
        <script src='https://www.google.com/recaptcha/api.js'></script>
    </head>
    <body onload="numberValue()">
    <#include "navbar.ftl">
    <div class="slider_area">
        <div class="single_slider  d-flex align-items-center slider_bg_1">
        </div>
    </div>

    <#nested>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"
            integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
            crossorigin="anonymous"></script>
    <script src="/static/script.js"></script>
    <script src="/static/js/jquery.slicknav.min.js"></script>
    <script src="/static/js/main.js"></script>
    </body>
    </html>
</#macro>
<#macro imgUploadForm>
    <div class="form-group" style="margin-top: 15px">
        <div class="custom-file">
            <input type="file" name="custom-file-input" class="custom-file-input" id="customFile"
                   onchange="upload(this.files[0])" accept="image/*">
            <img src="https://klimaschutz-praxis.de/fileadmin/images/fallback.png" class="rounded-circle minimized" width="75px"
                 id="foto">
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
            <input type="range" class="form-control-range" min="1" max="100"
                   value="<#if !deals??>${deal.period}<#else>30</#if>" id="periodStr" name="period"
                   oninput="periodUpdate(value)">
            <br/><br/>
            <label for="amountStr">Желаемая сумма </label>
            <b><u>
                    <output for="amountStr" id="amount_value"><#if !deals??>${deal.amount}<#else>100</#if></output>
                </u></b>
            <label for="amountStr"> рублей.</label>
            <input type="range" class="form-control-range" min="10" max="3000"
                   value="<#if !deals??>${deal.amount}<#else>100</#if>" id="amountStr" name="amount"
                   oninput="amountUpdate(value)">
            <br/><br/>
            <label for="percentStr">Оплата за пользование не более </label>
            <b><u>
                    <output for="percentStr" id="percent_value"><#if !deals??>${deal.percent}<#else>20</#if></output>
                </u></b>
            <label for="percentStr"> % в 30 дней.</label>
            <input type="range" class="form-control-range" min="1" max="100"
                   value="<#if !deals??>${deal.percent}<#else>20</#if>" step="0.1" id="percentStr"
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
                <input type="text" class="form-control ${(commentError??)?string('is-invalid', '')}"
                       value="<#if !deals??>${deal.comment}</#if>" name="comment"
                       placeholder="Ваш комментарий..."/>
                <#if commentError??>
                    <div class="invalid-feedback">
                        ${commentError}
                    </div>
                </#if>
            </div>
            <a class="boxed-btn3" data-toggle="collapse" href="#collapseExample1" role="button"
               aria-expanded="false" aria-controls="collapseExample1">
                Добавить фото залогового товара...
            </a>
            <br/>
            <div class="collapse <#if message??>show</#if>" id="collapseExample1">
                <@c.imgUploadForm></@c.imgUploadForm>
            </div>
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <#if !deals??><input type="hidden" name="id" value="${deal.id}"/></#if>
            <div class="form-group">
                <button type="submit" class="boxed-btn3"
                        style="margin-top: 15px"><#if !deals??>Сохранить<#else>Добавить</#if></button>
            </div>
        </form>
    </div>
</#macro>
<#macro dealTable>
    <div class="job_listing_area">
        <div class="container">
            <div class="job_lists">
                <div class="row">
                    <div class="col-lg-12 col-md-12">
                        <div class="single_jobs white-bg d-flex justify-content-between">
                            <div class="jobs_left d-flex align-items-center">
                                <div class="date" align="center" style="margin-right: 20px">
                                    ${deal.datePlacement?string('dd.MM.yyyy')}
                                    <br/><br/><br/>
                                    <#if deal.authorAvatar??>
                                        <img src="${deal.authorAvatar}" class="rounded-circle" width="50px">
                                    </#if>
                                    <p> ${deal.authorName}</p>
                                </div>
                                <div class="jobs_conetent">
                                    <h4>${deal.comment}</h4>
                                    <#if imagess??>
                                        <#list imagess as images>
                                            <#if images.image?? && images.message == deal>
                                                <div class="image__wrapper">
                                                    <img src="${images.image}" class="minimized"
                                                         alt="клик для увеличения">
                                                </div>
                                            </#if>
                                        </#list>
                                    </#if>
                                    <div class="links_locat d-flex align-items-center">
                                        <div class="location">Сумма: ${deal.amount} руб.</div>
                                        <div class="location">Срок: ${deal.period} дней.</div>
                                        <div class="location">Процент не выше: ${deal.percent}% за 30 дней.
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="jobs_right">
                                <div class="apply_now">
                                    <#if name == deal.authorName || isAdmin || isModerator >
                                        <div class="d-block">
                                            <form action="/deal/edit/${deal.id}" method="get">
                                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                                <div class="form-group">
                                                    <button type="submit" class="boxed-btn3">Редактировать...
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </#if>
                                    <#if deal.isActive()>
                                        <#if name == deal.authorName || isAdmin>
                                            <div class="d-block">
                                                <form action="/deal/disable/${deal.id}" method="get"
                                                      onsubmit="return confirm('Вы уверены?');">
                                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                                    <div class="form-group">
                                                        <button type="submit" class="boxed-btn3">Деактивировать
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </#if>
                                    <#else>
                                        Заявка неактивна.
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>
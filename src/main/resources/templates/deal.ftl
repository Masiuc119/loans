<#import "parts/common.ftl" as c>

<@c.page>
    <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false"
       aria-controls="collapseExample">
        Создать новую заявку...
    </a>
    <div class="collapse <#if message??>show</#if>" id="collapseExample">
        <div class="form-group mt-3">
            <form method="post" enctype="multipart/form-data">
                <label for="periodStr">Срок займа </label>
                <b><u>
                        <output for="periodStr" id="period_value">30</output>
                    </u></b>
                <label for="periodStr"> дней.</label>
                <input type="range" class="custom-range" min="1" max="100" value="30" id="periodStr" name="period"
                       oninput="periodUpdate(value)">
                <br/><br/>
                <label for="amountStr">Желаемая сумма </label>
                <b><u>
                        <output for="amountStr" id="amount_value">100</output>
                    </u></b>
                <label for="amountStr"> рублей.</label>
                <input type="range" class="custom-range" min="10" max="3000" value="100" id="amountStr" name="amount"
                       oninput="amountUpdate(value)">
                <br/><br/>
                <label for="percentStr">Оплата за пользование не более </label>
                <b><u>
                        <output for="percentStr" id="percent_value">20</output>
                    </u></b>
                <label for="percentStr"> % в 30 дней.</label>
                <input type="range" class="custom-range" min="1" max="100" value="20" step="0.1" id="percentStr"
                       name="percent"
                       oninput="percentUpdate(value)">
                <br/>
                <small class="form-text text-muted">
                    Ориентировочно полная сумма к погашению составит <output for="percentStr amountStr periodStr" id="summ_value">0</output> рублей.
                </small>
                <br/>
                <div class="form-group">
                    <input type="text" class="form-control ${(textError??)?string('is-invalid', '')}"
                           value="<#if message??>${message.text}</#if>" name="comment"
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
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Добавить</button>
                </div>
            </form>
        </div>
    </div>
    <div class="card-columns">
        <#list deals as deal>
            <div class="card my-3">
                <#if imagess??>
                    <#list imagess as images>
                        <#if images.image?? && images.message == deal>
                            <img src="${images.image}" class="card-img-top">
                        </#if>
                    </#list>
                </#if>
                <div class="m-2">
                    <span>${deal.comment}</span>
                    <i>${deal.amount}</i>
                </div>
                <div class="card-footer text-muted">
                    <#if deal.authorAvatar??>
                        <img src="${deal.authorAvatar}" class="rounded-circle" width="64px">
                    </#if>
                    ${deal.authorName}
                </div>
            </div>
        <#else>
            No message
        </#list>
    </div>
</@c.page>
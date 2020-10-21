<#include "parts/security.ftl">
<#import "parts/common.ftl" as c>

<@c.page>
    Заявка №${deal.id}

    <div>
        <table width="100%">
            <#if deal??>
                <tr class="table-primary">
                    <th width="25%">
                        <#if deal.authorAvatar??>
                            <img src="${deal.authorAvatar}" class="rounded-circle" width="32px">
                        </#if>
                        ${deal.authorName}
                    </th>
                    <th width="60%">
                        ${deal.datePlacement?string('dd.MM.yyyy HH:mm:ss')}
                    </th>
                    <th>
                        <small class="form-text text-muted">  ${deal.id}</small>
                    </th>
                </tr>
                <tr class="table-secondary">
                    <td>
                        Сумма: ${deal.amount} руб.
                    </td>
                    <td rowspan="3">
                        ${deal.comment}
                        <#if imagess??>
                            <#list imagess as images>
                                <#if images.image?? && images.message == deal>
                                    <div class="image__wrapper">
                                        <img src="${images.image}" class="minimized" alt="клик для увеличения">
                                    </div>
                                </#if>
                            </#list>
                        </#if>
                    </td>
                    <td rowspan="3">
                        <#if name == deal.authorName || isAdmin || isModerator >
                            <form action="/deal/edit/${deal.id}" method="get">
                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                <button type="submit" class="btn btn-primary">Редактировать...</button>
                            </form>
                        </#if>
                        <#if deal.isActive()>
                            <#if name == deal.authorName || isAdmin>
                                <form action="/deal/disable/${deal.id}" method="get"
                                      onsubmit="return confirm('Вы уверены?');">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Деактивировать</button>
                                    </div>
                                </form>
                            </#if>
                        <#else>
                            Заявка неактивна.
                        </#if>
                    </td>
                </tr>
                <tr class="table-secondary">
                    <td>
                        Срок: ${deal.period} дней.
                    </td>
                </tr>
                <tr class="table-secondary">
                    <td>
                        Процент не выше: ${deal.percent}% за 30 дней.
                    </td>
                </tr>
                <tr class="table-light">
                    <td colspan="3" height="15">

                    </td>
                </tr>
            <#else>
                Нет заявок
            </#if>
        </table>
    </div>
    <#if name != deal.authorName>
        <#if !feedbackEdit??>
            <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button"
               aria-expanded="false"
               aria-controls="collapseExample">
                Добавить отклик на заявку...
            </a>
        </#if>
        <div class="collapse <#if isNew>show</#if>" id="collapseExample">
            <div class="form-group mt-3">
                <form method="post"
                      action="<#if !feedbackEdit??>/deal/newFeedback/${deal.id}<#else >/deal/editFeedback/${feedbackEdit.id}</#if>"
                      enctype="multipart/form-data">
                    <label for="periodStr">Срок займа </label>
                    <b><u>
                            <output for="periodStr"
                                    id="period_value"><#if !feedbackEdit??>${deal.period}<#else >${feedbackEdit.period}</#if></output>
                        </u></b>
                    <label for="periodStr"> дней.</label>
                    <input type="range" class="custom-range" min="1" max="100"
                           value="<#if !feedbackEdit??>${deal.period}<#else >${feedbackEdit.period}</#if>"
                           id="periodStr" name="period"
                           oninput="periodUpdate(value)" <#if isNew>autofocus</#if>>
                    <br/><br/>
                    <label for="amountStr">Сумма </label>
                    <b><u>
                            <output for="amountStr"
                                    id="amount_value"><#if !feedbackEdit??>${deal.amount}<#else >${feedbackEdit.amount}</#if></output>
                        </u></b>
                    <label for="amountStr"> рублей.</label>
                    <input type="range" class="custom-range" min="10" max="3000"
                           value="<#if !feedbackEdit??>${deal.amount}<#else >${feedbackEdit.amount}</#if>"
                           id="amountStr" name="amount"
                           oninput="amountUpdate(value)">
                    <br/><br/>
                    <label for="percentStr">Оплата за пользование не более </label>
                    <b><u>
                            <output for="percentStr"
                                    id="percent_value"><#if !feedbackEdit??>${deal.percent}<#else >${feedbackEdit.percent}</#if></output>
                        </u></b>
                    <label for="percentStr"> % в 30 дней.</label>
                    <input type="range" class="custom-range" min="1" max="100"
                           value="<#if !feedbackEdit??>${deal.percent}<#else >${feedbackEdit.percent}</#if>" step="0.1"
                           id="percentStr"
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
                               name="comment" placeholder="Ваш комментарий..."
                               <#if feedbackEdit??>value="${feedbackEdit.comment}"</#if>/>
                        <#if commentError??>
                            <div class="invalid-feedback">
                                ${commentError}
                            </div>
                        </#if>
                    </div>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <div class="form-group">
                        <button type="submit"
                                class="btn btn-primary"><#if !feedbackEdit??>Добавить<#else >Сохранить</#if></button>
                    </div>
                </form>
            </div>
        </div>
    </#if>
    <#if !feedbackEdit??>
        <div>
            <table width="90%" align="right">
                <#list feedbacks as feedback>
                    <tr class="table-primary">
                        <th width="25%">
                            <#if feedback.authorAvatar??>
                                <img src="${feedback.authorAvatar}" class="rounded-circle" width="32px">
                            </#if>
                            ${feedback.authorName}
                        </th>
                        <th width="60%">
                            ${feedback.datePlacement?string('dd.MM.yyyy HH:mm:ss')}
                        </th>
                        <th>
                            <small class="form-text text-muted">  ${feedback.id}</small>
                        </th>
                    </tr>
                    <tr class="table-secondary">
                        <td>
                            Сумма: <font
                                    color="<#if (feedback.amount > deal.amount)>green<#elseif (feedback.amount < deal.amount)>red<#else>black</#if> ">${feedback.amount}</font>
                            руб.
                        </td>
                        <td rowspan="3">
                            ${feedback.comment}
                        </td>
                        <td rowspan="3">
                            <#if name == feedback.authorName || isAdmin || isModerator >
                                <form action="/deal/editFeedback/${feedback.id}" method="get">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-primary">Редактировать...</button>
                                </form>
                            </#if>
                            <#if name = deal.authorName>
                                <div class="form-group">
                                    <button type="button" class="btn btn-primary">Принять предложение...</button>
                                </div>
                            </#if>
                        </td>
                    </tr>
                    <tr class="table-secondary">
                        <td>
                            Срок: <font
                                    color="<#if (feedback.period > deal.period)>green<#elseif (feedback.period < deal.period)>red<#else>black</#if> ">${feedback.period}</font>
                            дней.
                        </td>
                    </tr>
                    <tr class="table-secondary">
                        <td>
                            Процент не выше:
                            <script>
                                document.writeln("<font color =")
                                if (${feedback.percent} < ${deal.percent}) {
                                    document.writeln("'green'>")
                                } else if (${feedback.percent} > ${deal.percent}) {
                                    document.writeln("'red'>")
                                } else {
                                    document.writeln("'black'>")
                                }
                            </script>
                            ${feedback.percent}</font>% за 30 дней.
                        </td>
                    </tr>
                    <tr class="table-light">
                        <td colspan="3" height="15">

                        </td>
                    </tr>
                <#else>
                    Нет откликов
                </#list>
            </table>
        </div>
    </#if>
</@c.page>

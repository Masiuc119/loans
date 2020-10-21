<#include "parts/security.ftl">
<#import "parts/common.ftl" as c>

<@c.page>
    <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false"
       aria-controls="collapseExample">
        Создать новую заявку...
    </a>
    <div class="collapse <#if deal??>show</#if>" id="collapseExample">
        <@c.dealForm></@c.dealForm>
    </div>
    <div>
        <table width="100%">
            <#list deals as deal>
                <#if deal.isActive()>
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
                            <#if name == deal.authorName || isAdmin>
                                <form action="/deal/disable/${deal.id}" method="get"
                                      onsubmit="return confirm('Вы уверены?');">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Деактивировать</button>
                                    </div>
                                </form>
                            </#if>
                            <#if name != deal.authorName>
                                <form action="/deal/${deal.id}" method="get">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Предложить займ...</button>
                                    </div>
                                </form>
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
                    <tr class="table-secondary">
                        <td></td>
                        <td colspan="2">
                            <a href="/deal/viewFeedbacks/${deal.id}">Всего МАЛО предложений получить займ.</a>
                        </td>
                    </tr>
                    <tr class="table-light">
                        <td colspan="3" height="15">

                        </td>
                    </tr>
                </#if>
            <#else>
                No message
            </#list>
        </table>
    </div>
</@c.page>
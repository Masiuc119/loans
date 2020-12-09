<#include "parts/security.ftl">
<#import "parts/common.ftl" as c>

<@c.page>
    <div class="job_listing_area">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="section_title">
                        <h3>Заявка №${deal.id}</h3>
                    </div>
                </div>
            </div>
            <@c.dealTable></@c.dealTable>
            <#if name != deal.authorName>
                <#if !feedbackEdit??>
                    <a class="boxed-btn3" data-toggle="collapse" href="#collapseExample" role="button"
                       aria-expanded="false"
                       aria-controls="collapseExample">
                        Добавить отклик на заявку...
                    </a>
                </#if>
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
                        <input type="range" class="form-control-range" min="1" max="100"
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
                        <input type="range" class="form-control-range" min="10" max="3000"
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
                        <input type="range" class="form-control-range" min="1" max="100"
                               value="<#if !feedbackEdit??>${deal.percent}<#else >${feedbackEdit.percent}</#if>"
                               step="0.1"
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
                                    class="boxed-btn3"><#if !feedbackEdit??>Добавить<#else >Сохранить</#if></button>
                        </div>
                    </form>
                    <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
                </div>
            </div>
            <#if !feedbackEdit??>
                <div class="job_listing_area">
                    <div class="container">
                        <div class="job_lists">
                            <div class="row">
                                <#list feedbacks as feedback>
                                    <div class="col-lg-12 col-md-12">
                                        <div class="single_jobs white-bg d-flex justify-content-between">
                                            <div class="jobs_left d-flex align-items-center">
                                                <div class="date" align="center" style="margin-right: 20px">
                                                    ${feedback.datePlacement?string('dd.MM.yyyy')}
                                                    <br/><br/><br/>
                                                    <#if feedback.authorAvatar??>
                                                        <img src="${feedback.authorAvatar}" class="rounded-circle"
                                                             width="50px">
                                                    </#if>
                                                    <p> ${feedback.authorName}</p>
                                                </div>
                                                <div class="jobs_conetent">
                                                    <h4>${feedback.comment}</h4>
                                                    <div class="links_locat d-flex align-items-center">
                                                        <div class="location">Сумма: <font
                                                                    color="<#if (feedback.amount > deal.amount)>green<#elseif (feedback.amount < deal.amount)>red<#else>black</#if> ">${feedback.amount}</font>
                                                            руб.
                                                        </div>
                                                        <div class="location">Срок: <font
                                                                    color="<#if (feedback.period > deal.period)>green<#elseif (feedback.period < deal.period)>red<#else>black</#if> ">${feedback.period}</font>
                                                            дней.
                                                        </div>
                                                        <div class="location">Процент не выше:
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
                                                            ${feedback.percent}</font>% за 30
                                                            дней.
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="jobs_right">
                                                <div class="apply_now">
                                                    <#if name == feedback.authorName || isAdmin || isModerator >
                                                        <div class="d-block">
                                                            <form action="/deal/editFeedback/${feedback.id}"
                                                                  method="get">
                                                                <input type="hidden" name="_csrf"
                                                                       value="${_csrf.token}"/>
                                                                <div class="form-group">
                                                                    <button type="submit" class="boxed-btn3">
                                                                        Редактировать...
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </#if>
                                                    <#if name = deal.authorName>
                                                        <div class="d-block">
                                                            <form action="/makeDeal/${feedback.id}" method="get">
                                                                <input type="hidden" name="_csrf"
                                                                       value="${_csrf.token}"/>
                                                                <div class="form-group">
                                                                    <button type="submit" class="boxed-btn3">Принять
                                                                        предложение...
                                                                    </button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </#if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <#else>
                                    Нет откликов
                                </#list>
                                <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
                            </div>
                        </div>
                    </div>
                </div>
            </#if>
        </div>
    </div>
</@c.page>

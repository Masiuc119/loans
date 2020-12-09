<#include "parts/security.ftl">
<#import "parts/common.ftl" as c>

<@c.page>
    <div class="catagory_area">
        <div class="container">
            <a class="boxed-btn3" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false"
               aria-controls="collapseExample">
                Создать новую заявку...
            </a>
            <div class="collapse <#if deal??>show</#if>" id="collapseExample">
                <@c.dealForm></@c.dealForm>
            </div>
        </div>
    </div>
    <div class="job_listing_area">
        <div class="container">
            <div class="job_lists">
                <div class="row">
                    <#list deals as deal>
                        <#if deal.isActive()>
                            <div class="col-lg-12 col-md-12">
                                <div class="single_jobs white-bg d-flex justify-content-between">
                                    <div class="jobs_left d-flex align-items-center">
                                        <a href="/deal/viewFeedbacks/${deal.id}">
                                        <div class="date" align="center" style="margin-right: 20px">
                                            ${deal.datePlacement?string('dd.MM.yyyy')}
                                            <br/><br/><br/>
                                            <#if deal.authorAvatar??>
                                                <img src="${deal.authorAvatar}" class="rounded-circle" width="50px">
                                            </#if>
                                            <p> ${deal.authorName}</p>
                                        </div>
                                        </a>
                                        <div class="jobs_conetent">
                                            <a href="/deal/viewFeedbacks/${deal.id}">
                                            <h4>${deal.comment}</h4>
                                            </a>
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
                                            <a href="/deal/viewFeedbacks/${deal.id}">
                                            <div class="links_locat d-flex align-items-center">
                                                <div class="location">Сумма: ${deal.amount} руб.</div>
                                                <div class="location">Срок: ${deal.period} дней.</div>
                                                <div class="location">Процент не выше: ${deal.percent}% за 30 дней.
                                                </div>
                                            </div>
                                            <div class="links_locat d-flex align-items-center" style="outline: 2px solid #000">
                                                <a href="/deal/viewFeedbacks/${deal.id}">Всего ${dealService.countFeedbackForDeal(deal.id)}
                                                    предложений получить займ.</a>
                                            </div>
                                            </a>
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
                                            <#if name != deal.authorName>
                                                <div class="d-block">
                                                    <form action="/deal/${deal.id}" method="get">
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                                        <div class="form-group">
                                                            <button type="submit" class="boxed-btn3">Предложить
                                                                займ...
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </#if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </#if>
                    <#else>
                        No message
                    </#list>
                </div>
            </div>
        </div>
    </div>
</@c.page>
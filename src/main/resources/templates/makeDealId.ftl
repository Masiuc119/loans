<#include "parts/security.ftl">
<#import "parts/common.ftl" as c>

<@c.page>
    <div class="job_listing_area">
        <div class="container">
            <div class="row align-items-center">
                <div class="col">
                    <div class="section_title" style="text-align: center">
                        <h3>
                            Принять предложение от ${feedback.author.username}.
                        </h3>
                    </div>
                    <div class="form-group">
                        <form method="post"
                              action="/makeDeal"
                              enctype="multipart/form-data">
                            <label for="periodStr">Срок займа </label>
                            <b><u>
                                    <output for="periodStr"
                                            id="period_value">${feedback.period}</output>
                                </u></b>
                            <label for="periodStr"> дней.</label>
                            <input type="range" class="form-control-range" min="1" max="${feedback.period}"
                                   value="${feedback.period}"
                                   id="periodStr" name="period"
                                   oninput="periodUpdate(value)">
                            <br/><br/>
                            <label for="amountStr">Сумма </label>
                            <b><u>
                                    <output for="amountStr"
                                            id="amount_value">${feedback.amount}</output>
                                </u></b>
                            <label for="amountStr"> рублей.</label>
                            <input type="range" class="form-control-range" min="10" max="${feedback.amount}"
                                   value="${feedback.amount}"
                                   id="amountStr" name="amount"
                                   oninput="amountUpdate(value)">
                            <br/><br/>
                            <label for="percentStr">Оплата за пользование не более </label>
                            <b><u>
                                    <output for="percentStr"
                                            id="percent_value">${feedback.percent}</output>
                                </u></b>
                            <label for="percentStr"> % в 30 дней.</label>
                            <input type="range" class="form-control-range" min="1" max="100"
                                   value="${feedback.percent}" step="0.1"
                                   id="percentStr"
                                   name="percent"
                                   oninput="percentUpdate(value)"
                                   disabled>
                            <br/>
                            <small class="form-text text-muted">
                                Ориентировочно полная сумма к погашению составит
                                <output for="percentStr amountStr periodStr" id="summ_value"></output>
                                рублей.
                            </small>
                            <br/>
                            <div class="form-group">
                                <input type="text" class="form-control"
                                       name="comment" placeholder="Ваш комментарий..."
                                       value="${feedback.comment}" disabled/>
                            </div>
                            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                            <input type="hidden" name="feedback_id" value="${feedback.id}"/>
                            <input type="hidden" name="deal_id" value="${deal.id}"/>
                            <div class="form-group">
                                <button type="submit"
                                        class="boxed-btn3">Отправить заявку на заключение сделки.
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <@c.dealTable></@c.dealTable>
</@c.page>

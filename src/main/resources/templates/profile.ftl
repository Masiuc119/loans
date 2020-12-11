<#import "parts/common.ftl" as c>

<@c.page>
    <div class="container">
        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist" style="margin-top: 20px">
            <li class="nav-item" role="presentation">
                <a class="nav-link active" id="pills-borrower-tab" data-toggle="pill" href="#pills-borrower" role="tab"
                   aria-controls="pills-borrower" aria-selected="false">Я должен</a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="pills-lender-tab" data-toggle="pill" href="#pills-lender" role="tab"
                   aria-controls="pills-lender" aria-selected="false">Мне должны</a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab"
                   aria-controls="pills-profile" aria-selected="true">Редактировать профиль</a>
            </li>
        </ul>
    </div>
    <div class="tab-content" id="pills-tabContent">
        <div class="tab-pane fade show active" id="pills-borrower" role="tabpanel" aria-labelledby="pills-borrower-tab">
            <table class="table_loans">
                <thead>
                <tr>
                    <td>
                        № п/п
                    </td>
                    <td>
                        Инвестор
                    </td>
                    <td>
                        Сумма займа
                    </td>
                    <td>
                        % по займу
                    </td>
                    <td>
                        Сумма к погашению (на сегодняшний день)
                    </td>
                    <td>
                        Остаток срока займа
                    </td>
                    <td>
                        Статус
                    </td>
                </tr>
                </thead>
                <tbody>
                <#list completedDealBorrower as completedDeal>
                    <#if completedDeal.isActive()>
                        <tr>
                            <td>
                                ${completedDeal_index + 1}
                            </td>
                            <td>
                                <#if completedDeal.lender.avatar??>
                                    <img src="${completedDeal.lender.avatar}" class="rounded-circle"
                                         width="32px">
                                </#if>
                                ${completedDeal.lender.username}
                            </td>
                            <td>
                                ${completedDeal.amount} рублей.
                            </td>
                            <td>
                                ${completedDeal.percent + " %"}
                            </td>
                            <td>
                                <#assign restDays = completedDeal.period - ((.now?date?long - completedDeal.date?date?long)/86400000)?round?int >
                                <#if completedDeal.statusDeal == "RECEIVEMONEY">
                                    ${(completedDeal.amount + (completedDeal.amount*(((completedDeal.percent/30)*(completedDeal.period - restDays))/100)))?string["0.##"]}
                                    рублей.
                                <#else>
                                    Сделка ещё не заключена.
                                </#if>
                            </td>
                            <td>
                                <#if (restDays > 0)>
                                    ${restDays} дней.
                                <#else>
                                    Срок добровольного погашения пропущен.
                                </#if>
                            </td>
                            <td>
                                <#if completedDeal.statusDeal == "CONFIRMBORROWER">
                                    Ожидается подтверждение заявки инвестором...
                                <#elseIf completedDeal.statusDeal == "CONFIRMLENDER">
                                    Заявка подтверждена инвестором. Ожидается перечисление денежных средств.
                                <#elseIf completedDeal.statusDeal == "TRANSFERMONEY">
                                    Денежные средства перечислены.
                                <form method="post" action="/setStatusCompDeal/${completedDeal.id}">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                    <input type="hidden" name="statusCompDeal" value="RECEIVEMONEY">
                                    <button type="submit" class="boxed-btn3">Подтвердить получение</button>
                                </form>
                                <#elseIf completedDeal.statusDeal == "RECEIVEMONEY">
                                    <form action="/addTransaction/${completedDeal.id}" method="post"
                                          onsubmit="return alert('Платеж принят. Изменения на баллансе произойдут после подтверждения платежа получателем.')">
                                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                        <input type="number" name="amount" value="0" min="1"/>
                                        <button type="submit" class="boxed-btn3">Внести платеж.</button>
                                    </form>
                                <#else>Ошибка!!! Статус не установлен.</#if>
                            </td>
                        </tr>
                    </#if>
                <#else>
                    <div class="section_title">
                        <h3 align="center">
                            Нет активных займов
                        </h3>
                    </div>
                </#list>
                </tbody>
            </table>
            <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
        </div>
        <div class="tab-pane fade" id="pills-lender" role="tabpanel" aria-labelledby="pills-lender-tab">
            <table class="table_loans">
                <thead>
                <tr>
                    <td>
                        № п/п
                    </td>
                    <td>
                        Заемщик
                    </td>
                    <td>
                        Сумма займа
                    </td>
                    <td>
                        % по займу
                    </td>
                    <td>
                        Сумма к погашению (на сегодняшний день)
                    </td>
                    <td>
                        Остаток срока займа
                    </td>
                    <td>
                        Статус
                    </td>
                </tr>
                </thead>
                <tbody>
                <#list completedDealLender as completedDeal>
                    <#if completedDeal.isActive()>
                        <tr>
                            <td>
                                ${completedDeal_index + 1}
                            </td>
                            <td>
                                <#if completedDeal.borrower.avatar??>
                                    <img src="${completedDeal.borrower.avatar}" class="rounded-circle"
                                         width="32px">
                                </#if>
                                ${completedDeal.borrower.username}
                            </td>
                            <td>
                                ${completedDeal.amount} рублей.
                            </td>
                            <td>
                                ${completedDeal.percent + " %"}
                            </td>
                            <td>
                                <#assign restDays = completedDeal.period - ((.now?date?long - completedDeal.date?date?long)/86400000)?round?int >
                                <#if completedDeal.statusDeal == "RECEIVEMONEY">
                                    ${(completedDeal.amount + (completedDeal.amount*(((completedDeal.percent/30)*(completedDeal.period - restDays))/100)))?string["0.##"]}
                                    рублей.
                                <#else>
                                    Сделка ещё не заключена.
                                </#if>
                            </td>
                            <td>
                                <#if (restDays > 0)>
                                    ${restDays} дней.
                                <#else>
                                    Срок добровольного погашения пропущен.
                                </#if>
                            </td>
                            <td>
                                <#if completedDeal.statusDeal == "CONFIRMBORROWER">
                                    <form method="post" action="/setStatusCompDeal/${completedDeal.id}">
                                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                        <input type="hidden" name="statusCompDeal" value="CONFIRMLENDER">
                                        <button type="submit" class="boxed-btn3">Подтвердить заключение сделки.
                                        </button>
                                    </form>
                                <#elseIf completedDeal.statusDeal == "CONFIRMLENDER">
                                    <form method="post" action="/setStatusCompDeal/${completedDeal.id}">
                                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                        <input type="hidden" name="statusCompDeal" value="TRANSFERMONEY">
                                        <button type="submit" class="boxed-btn3">Перечислить денежные средства.
                                        </button>
                                    </form>
                                <#elseIf completedDeal.statusDeal == "TRANSFERMONEY">
                                    Ожидание подтверждения заемщиком получения денежных средств....
                                <#elseIf completedDeal.statusDeal == "RECEIVEMONEY">
                                    <#list transactions as transaction>
                                        <#if transaction.completedDeal == completedDeal>
                                            <form method="post" action="/setTransaction/${transaction.id}"
                                                  onsubmit="return confirm('Подтвердить принятие суммы ${transaction.amount} рублей?')">
                                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                                Поступил платеж на сумму:
                                                <input type="text" value="${transaction.amount}" disabled/>
                                                рублей.
                                                <button type="submit" class="boxed-btn3">Подтвердить прием
                                                    платежа.
                                                </button>
                                            </form>
                                        <#else>
                                            Ожидание поступления платежа
                                        </#if>
                                    </#list>
                                <#else>Ошибка!!! Статус не установлен.</#if>
                            </td>
                        </tr>
                    </#if>
                <#else>
                    <div class="section_title">
                        <h3 align="center">
                            Нет активных займов
                        </h3>
                    </div>
                </#list>
                </tbody>
            </table>
            <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
        </div>
        <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
            <div class="container">
                <h5>  <#if avatar??>
                        <img src="${avatar}" class="rounded-circle" width="75px">
                    </#if>
                    ${username}</h5>
                ${message?ifExists}
                <form method="post" action="/user/profile">
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">Новое фото профиля:</label>
                        <div class="col-sm-6">
                            <@c.imgUploadForm></@c.imgUploadForm>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">Новый пароль:</label>
                        <div class="col-sm-6">
                            <input type="password" name="password" class="form-control" placeholder="Password"/>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">Новый email:</label>
                        <div class="col-sm-6">
                            <input type="email" name="email" class="form-control" placeholder="some@some.com"
                                   value="${email!''}"/>
                        </div>
                    </div>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <button class="boxed-btn3" type="submit">Сохранить изменения</button>
                    <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
                </form>
            </div>
        </div>
    </div>
</@c.page>

<#import "parts/common.ftl" as c>

<@c.page>
    <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
        <li class="nav-item" role="presentation">
            <a class="nav-link active" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab"
               aria-controls="pills-profile" aria-selected="true">Редактировать профиль</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="pills-borrower-tab" data-toggle="pill" href="#pills-borrower" role="tab"
               aria-controls="pills-borrower" aria-selected="false">Я должен</a>
        </li>
        <li class="nav-item" role="presentation">
            <a class="nav-link" id="pills-lender-tab" data-toggle="pill" href="#pills-lender" role="tab"
               aria-controls="pills-lender" aria-selected="false">Мне должны</a>
        </li>
    </ul>
    <div class="tab-content" id="pills-tabContent">
        <div class="tab-pane fade show active" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
            <h5>  <#if avatar??>
                    <img src="${avatar}" class="rounded-circle" width="256px">
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
                <button class="btn btn-primary" type="submit">Сохранить изменения</button>
            </form>
        </div>
        <div class="tab-pane fade" id="pills-borrower" role="tabpanel" aria-labelledby="pills-borrower-tab">
            <table width="100%">
                <tr class="table-primary">
                    <th>
                        № п/п
                    </th>
                    <th>
                        Кредитор
                    </th>
                    <th>
                        Сумма займа
                    </th>
                    <th>
                        % по займу
                    </th>
                    <th>
                        Сумма к погашению (на сегодняшний день)
                    </th>
                    <th>
                        Остаток срока займа
                    </th>
                    <th>
                        Статус
                    </th>
                </tr>
                <#list completedDealBorrower as completedDeal>
                    <#if completedDeal.isActive()>
                        <tr class="table-secondary">
                            <td>
                                ${completedDeal_index + 1}
                            </td>
                            <td>
                                <#if completedDeal.lender.avatar??>
                                    <img src="${completedDeal.lender.avatar}" class="rounded-circle" width="32px">
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
                                ${(completedDeal.amount + (completedDeal.amount*(((completedDeal.percent/30)*(completedDeal.period - restDays))/100)))?string["0.##"]}
                                рублей.
                            </td>
                            <td>
                                <#if (restDays > 0)>${restDays} дней.<#else>Срок добровольного погашения пропущен. Коллекторы уже в пути. </#if>
                            </td>
                            <td>
                                <#if completedDeal.statusDeal == "CONFIRMLENDER" || completedDeal.statusDeal == "CONFIRMBORROWER">
                                    Ожидается подтверждение заявки кредитором и перечисление денежных средств.....
                                <#elseIf completedDeal.statusDeal == "TRANSFERMONEY">
                                    Денежные средства перечислены.
                                    <button type="button" class="btn btn-primary">Подтвердить получение</button>
                                <#elseIf completedDeal.statusDeal == "RECEIVEMONEY">
                                    <form action="/addTransaction/${completedDeal.id}" method="post"
                                          onsubmit="return alert('Платеж принят. Изменения на баллансе произойдут после подтверждения платежа получателем.')">
                                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                        <input type="number" name="amount" value="0" min="1"/>
                                        <button type="submit" class="btn btn-primary">Внести платеж.</button>
                                    </form>
                                <#else>Ошибка!!! Статус не установлен.</#if>
                            </td>
                        </tr>
                        <tr class="table-light">
                            <td colspan="7" height="15"></td>
                        </tr>
                    </#if>
                <#else>
                    Нет активных займов
                </#list>
            </table>
        </div>
        <div class="tab-pane fade" id="pills-lender" role="tabpanel" aria-labelledby="pills-lender-tab">
            <table width="100%">
                <tr class="table-primary">
                    <th>
                        № п/п
                    </th>
                    <th>
                        Дебитор
                    </th>
                    <th>
                        Сумма займа
                    </th>
                    <th>
                        % по займу
                    </th>
                    <th>
                        Сумма к погашению (на сегодняшний день)
                    </th>
                    <th>
                        Остаток срока займа
                    </th>
                    <th>
                        Статус
                    </th>
                </tr>
                <#list completedDealLender as completedDeal>
                    <#if completedDeal.isActive()>
                        <tr class="table-secondary">
                            <td>
                                ${completedDeal_index + 1}
                            </td>
                            <td>
                                <#if completedDeal.borrower.avatar??>
                                    <img src="${completedDeal.borrower.avatar}" class="rounded-circle" width="32px">
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
                                ${(completedDeal.amount + (completedDeal.amount*(((completedDeal.percent/30)*(completedDeal.period - restDays))/100)))?string["0.##"]}
                                рублей.
                            </td>
                            <td>
                                <#if (restDays > 0)>${restDays} дней.<#else>Срок добровольного погашения пропущен.
                                    <button type="button" class="btn btn-primary">Отправить коллекторов.</button></#if>
                            </td>
                            <td>
                                <#if completedDeal.statusDeal == "CONFIRMLENDER">
                                    <button type="button" class="btn btn-primary">Подтвердить заключение сделки.
                                    </button>
                                <#elseIf completedDeal.statusDeal == "CONFIRMBORROWER">
                                    <button type="button" class="btn btn-primary">Перечислить денежные средства.
                                    </button>
                                <#elseIf completedDeal.statusDeal == "TRANSFERMONEY">
                                    Ожидание подтверждения дебитором получения денежных средств....
                                <#elseIf completedDeal.statusDeal == "RECEIVEMONEY">
                                    <#list transactions as transaction>
                                        <#if transaction.completedDeal == completedDeal>
                                            <form method="post" action="/setTransaction/${transaction.id}"
                                                  onsubmit="return confirm('Подтвердить принятие суммы ${transaction.amount} рублей?')">
                                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                                Поступил платеж на сумму:
                                                <input type="text" value="${transaction.amount}" disabled/>
                                                рублей.
                                                <button type="submit" class="btn btn-primary">Подтвердить прием платежа.
                                                </button>
                                            </form>
                                        </#if>
                                    </#list>
                                <#else>Ошибка!!! Статус не установлен.</#if>
                            </td>
                        </tr>
                        <tr class="table-light">
                            <td colspan="7" height="15"></td>
                        </tr>
                    </#if>
                <#else>
                    Нет активных займов
                </#list>
            </table>
        </div>
    </div>
</@c.page>

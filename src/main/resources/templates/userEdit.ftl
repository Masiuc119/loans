<#import "parts/common.ftl" as c>

<@c.page>
    <div class="job_listing_area">
        <div class="container">
            <div class="row align-items-center">
                <div class="col">
                    <div class="section_title" style="text-align: center">
                        <h3>
                            Профиль пользователя ${user.username}
                        </h3>
                    </div>
                    <form action="/user" method="post">
                        <input type="text" name="username" value="${user.username}">
                        <#list roles as role>
                            <div class="custom-control custom-checkbox mb-3">
                                <input class="custom-control-input" type="checkbox" id="${role_index + 1}" name="${role}" ${user.roles?seq_contains(role)?string("checked", "")}>
                                <label class="custom-control-label" for="${role_index + 1}">
                                    ${role}
                                </label>
                            </div>
                        </#list>
                        <input type="hidden" value="${user.id}" name="userId">
                        <input type="hidden" value="${_csrf.token}" name="_csrf">
                        <button class="boxed-btn3" type="submit">Сохранить</button>
                        <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
                    </form>
                </div>
            </div>
        </div>
    </div>
</@c.page>

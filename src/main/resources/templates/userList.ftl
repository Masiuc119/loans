<#import "parts/common.ftl" as c>

<@c.page>
    <div class="job_listing_area">
        <div class="container">
            <div class="row align-items-center">
                <div class="col">
                    <div class="section_title" style="text-align: center">
                        <h3>
                            Панель администратора
                        </h3>
                    </div>
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Имя пользователя</th>
                            <th>Права доступа</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list users as user>
                            <tr>
                                <td><#if user.avatar??>
                                        <img src="${user.avatar}" class="rounded-circle" width="32px">
                                    </#if>
                                    ${user.username}</td>
                                <td><#list user.roles as role>${role}<#sep>, </#list></td>
                                <td><a class="boxed-btn3" href="/user/${user.id}">Изменить</a></td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                    <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
                </div>
            </div>
        </div>
    </div>
</@c.page>

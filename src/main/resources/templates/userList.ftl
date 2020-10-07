<#import "parts/common.ftl" as c>

<@c.page>
Панель администратора

<table>
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
            <td>${user.username}</td>
            <td><#list user.roles as role>${role}<#sep>, </#list></td>
            <td><a href="/user/${user.id}">Изменить</a></td>
        </tr>
    </#list>
    </tbody>
</table>
</@c.page>

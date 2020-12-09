<#import "parts/common.ftl" as c>
<#import "parts/login.ftl" as l>

<@c.page>
    <div class="section_title" style="text-align: center">
        <h3>Зарегистрироваться</h3></div>
    ${message?ifExists}
    <@l.login "/registration" true />
</@c.page>

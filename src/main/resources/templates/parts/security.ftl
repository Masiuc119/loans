<#assign
    known = Session.SPRING_SECURITY_CONTEXT??
>

<#if known>
    <#assign
        user = Session.SPRING_SECURITY_CONTEXT.authentication.principal
        name = user.getUsername()
        isAdmin = user.isAdmin()
        button = "Выйти"
    >
<#else>
    <#assign
        name = "Не авторизован"
        button = "Войти"
        isAdmin = false
    >
</#if>

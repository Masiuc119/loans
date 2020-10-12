<#assign
    known = Session.SPRING_SECURITY_CONTEXT??
>

<#if known>
    <#assign
        user = Session.SPRING_SECURITY_CONTEXT.authentication.principal
        id = user.getId()
        name = user.getUsername()
        isAdmin = user.isAdmin()
        isModerator = user.isModerator()
        button = "Выйти"
    >
<#else>
    <#assign
        id = "null"
        name = "Не авторизован"
        button = "Войти"
        isAdmin = false
        isModerator = false
    >
</#if>

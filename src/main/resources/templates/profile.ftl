<#import "parts/common.ftl" as c>

<@c.page>
    <h5>
        <#if avatar??>
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
                <input type="email" name="email" class="form-control" placeholder="some@some.com" value="${email!''}"/>
            </div>
        </div>
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <button class="btn btn-primary" type="submit">Сохранить изменения</button>
    </form>
</@c.page>

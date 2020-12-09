<#macro login path isRegisterForm>
    <div class="job_listing_area">
        <div class="container">
            <div class="job_listing_area">
                <div class="container">
                    <div class="job_lists">
                        <form action="${path}" method="post">
                            <div class="col"><label>Логин:</label></div>
                            <input type="text" name="username" value="<#if user??>${user.username}</#if>"
                                   class="form-control ${(usernameError??)?string('is-invalid', '')}"
                                   placeholder="User name"/>
                            <#if usernameError??>
                                <div class="invalid-feedback">
                                    ${usernameError}
                                </div>
                            </#if>
                            <div class="col"><label>Пароль:</label></div>
                            <input type="password" name="password"
                                   class="form-control ${(passwordError??)?string('is-invalid', '')}"
                                   placeholder="Password"/>
                            <#if passwordError??>
                                <div class="invalid-feedback">
                                    ${passwordError}
                                </div>
                            </#if>
                            <#if isRegisterForm>
                                <div class="col"><label>Повторите пароль:</label></div>
                                <input type="password" name="password2"
                                       class="form-control ${(password2Error??)?string('is-invalid', '')}"
                                       placeholder="Retype password"/>
                                <#if password2Error??>
                                    <div class="invalid-feedback">
                                        ${password2Error}
                                    </div>
                                </#if>
                                <div class="col"><label>Email:</label></div>
                                <input type="email" name="email" value="<#if user??>${user.email}</#if>"
                                       class="form-control ${(emailError??)?string('is-invalid', '')}"
                                       placeholder="some@some.com"/>
                                <#if emailError??>
                                    <div class="invalid-feedback">
                                        ${emailError}
                                    </div>
                                </#if>
                                <div class="col" style="margin: 15px">
                                    <div class="g-recaptcha"
                                         data-sitekey="6LdPOM4ZAAAAADyUkM09Rg7BsT5zmJXAOtBGlRac"></div>
                                    <#if captchaError??>
                                        <div class="alert alert-danger" role="alert">
                                            ${captchaError}
                                        </div>
                                    </#if>
                                </div>
                            </#if>
                            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                            <div class="col" style="margin: 15px">
                                <#if !isRegisterForm><a class="boxed-btn3" href="/registration">У меня еще нет
                                    аккаунта.</a></#if>
                                <button class="boxed-btn3"
                                        type="submit"><#if isRegisterForm>Зарегистрироваться<#else>Войти</#if></button>
                                <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro logout>
    <#include "security.ftl">
    <div class="d-none d-lg-block">
        <form action="/logout" method="post">
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <button class="boxed-btn3" type="submit">${button}</button>
        </form>
    </div>
</#macro>

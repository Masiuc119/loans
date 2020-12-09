<#include "security.ftl">
<#import "login.ftl" as l>

<header>
    <div class="header-area ">
        <div id="sticky-header" class="main-header-area">
            <div class="container-fluid ">
                <div class="header_bottom_border">
                    <div class="row align-items-center">
                        <div class="col-xl-2 col-lg-2">
                            <div class="logo">
                                <a href="/">
                                    <img src="/static/img/logo.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="col-xl-8 col-lg-8">
                            <div class="main-menu  d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <li><a href="/">Домой</a></li>
                                        <li><a href="/deal">Заявки на займы</a></li>
                                        <#if isAdmin>
                                            <li><a href="/user">Панель администратора</a></li>
                                        </#if>
                                        <#if user??>
                                            <li><a href="/user/profileEdit">Личный кабинет</a></li>
                                        </#if>
                                        <li>
                                        <#if user??>
                                            <#if user.avatar??>
                                                <img src="${user.avatar}" class="rounded-circle" width="32px">
                                            </#if>
                                        </#if>
                                        ${name}
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                        <div class="col-xl-2 col-lg-2 d-none d-lg-block">
                            <div class="Appointment">
                                <@l.logout />
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="mobile_menu d-block d-lg-none"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

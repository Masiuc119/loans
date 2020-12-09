<#include "parts/security.ftl">
<#import "parts/common.ftl" as c>

<@c.page>
    <div class="job_listing_area">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="section_title">
                        <h3>Редактировать заявку №${deal.id}</h3>
                    </div>
                </div>
            </div>
            <@c.dealForm></@c.dealForm>
            <input class="boxed-btn3" type="button" onclick="history.back();" value="Назад"/>
        </div>
    </div>
</@c.page>

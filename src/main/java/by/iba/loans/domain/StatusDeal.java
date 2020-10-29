package by.iba.loans.domain;

public enum StatusDeal {
    CONFIRMLENDER, //подтвердил кредитодатель
    CONFIRMBORROWER, //подтвердил кредитополучатель
    TRANSFERMONEY,//кредитодатель передал деньги
    RECEIVEMONEY;//кредитополучатель получил деньги
}

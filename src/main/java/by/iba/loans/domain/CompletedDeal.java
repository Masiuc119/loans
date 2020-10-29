package by.iba.loans.domain;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.Date;

@Entity
public class CompletedDeal {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private Date date;
    private int amount;
    private int period;
    private float percent;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "userLender_id")
    private User lender; //дал кредит
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "userBorrower_id")
    private User borrower; //взял кредит
    @OneToOne
    @JoinColumn(name = "deal_id")
    private Deal deal;
    @OneToOne
    @JoinColumn(name = "feedback_id")
    private Feedback feedback;
    private boolean active; //активна ли сделка
    private StatusDeal statusDeal;

    public CompletedDeal() {
    }

    public CompletedDeal(Date date,
                         int amount,
                         int period,
                         float percent,
                         @NotBlank(message = "Поле не может быть пустым")
                                 User lender,
                         @NotBlank(message = "Поле не может быть пустым")
                                 User borrower,
                         Deal deal,
                         Feedback feedback,
                         @NotBlank
                                 boolean active,
                         @NotBlank
                                 StatusDeal statusDeal) {
        this.date = date;
        this.amount = amount;
        this.period = period;
        this.percent = percent;
        this.lender = lender;
        this.borrower = borrower;
        this.deal = deal;
        this.feedback = feedback;
        this.active = active;
        this.statusDeal = statusDeal;
    }

    public CompletedDeal(Long id,
                         Date date,
                         int amount,
                         int period,
                         float percent,
                         @NotBlank(message = "Поле не может быть пустым")
                                 User lender,
                         @NotBlank(message = "Поле не может быть пустым")
                                 User borrower,
                         Deal deal,
                         Feedback feedback,
                         @NotBlank
                                 boolean active,
                         @NotBlank
                                 StatusDeal statusDeal) {
        this.id = id;
        this.date = date;
        this.amount = amount;
        this.period = period;
        this.percent = percent;
        this.lender = lender;
        this.borrower = borrower;
        this.deal = deal;
        this.feedback = feedback;
        this.active = active;
        this.statusDeal = statusDeal;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public int getPeriod() {
        return period;
    }

    public void setPeriod(int period) {
        this.period = period;
    }

    public float getPercent() {
        return percent;
    }

    public void setPercent(float percent) {
        this.percent = percent;
    }

    public User getLender() {
        return lender;
    }

    public void setLender(User lender) {
        this.lender = lender;
    }

    public User getBorrower() {
        return borrower;
    }

    public void setBorrower(User borrower) {
        this.borrower = borrower;
    }

    public Deal getDeal() {
        return deal;
    }

    public void setDeal(Deal deal) {
        this.deal = deal;
    }

    public Feedback getFeedback() {
        return feedback;
    }

    public void setFeedback(Feedback feedback) {
        this.feedback = feedback;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public StatusDeal getStatusDeal() {
        return statusDeal;
    }

    public void setStatusDeal(StatusDeal statusDeal) {
        this.statusDeal = statusDeal;
    }

}

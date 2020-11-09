package by.iba.loans.domain;

import javax.persistence.*;
import java.util.Date;

@Entity
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private Date date;
    private int amount;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User author;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "completedDeal_id")
    private CompletedDeal completedDeal;

    public Transaction() {
    }

    public Transaction(Long id, Date date, int amount, User author, CompletedDeal completedDeal) {
        this.id = id;
        this.date = date;
        this.amount = amount;
        this.author = author;
        this.completedDeal = completedDeal;
    }

    public Transaction(Date date, int amount, User author, CompletedDeal completedDeal) {
        this.date = date;
        this.amount = amount;
        this.author = author;
        this.completedDeal = completedDeal;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public CompletedDeal getCompletedDeal() {
        return completedDeal;
    }

    public void setCompletedDeal(CompletedDeal completedDeal) {
        this.completedDeal = completedDeal;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}

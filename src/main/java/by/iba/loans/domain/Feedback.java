package by.iba.loans.domain;

import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.Date;

@Entity
public class Feedback {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private Date datePlacement;
    private int amount;
    private int period;
    private float percent;
    @NotBlank(message = "Поле не может быть пустым")
    @Length(max = 2048, message = "Сообщение слишком длинное (максимум 2kB)")
    private String comment;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User author;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "deal_id")
    private Deal message;

    public Feedback(Long id,
                    Date datePlacement,
                    int amount,
                    int period,
                    float percent,
                    @NotBlank(message = "Поле не может быть пустым")
                    @Length(max = 2048, message = "Сообщение слишком длинное (максимум 2kB)")
                            String comment,
                    User author,
                    Deal message) {
        this.id = id;
        this.datePlacement = datePlacement;
        this.amount = amount;
        this.period = period;
        this.percent = percent;
        this.comment = comment;
        this.author = author;
        this.message = message;
    }

    public Feedback(Date datePlacement,
                    int amount,
                    int period,
                    float percent,
                    @NotBlank(message = "Поле не может быть пустым")
                    @Length(max = 2048, message = "Сообщение слишком длинное (максимум 2kB)")
                            String comment,
                    User author,
                    Deal message) {
        this.datePlacement = datePlacement;
        this.amount = amount;
        this.period = period;
        this.percent = percent;
        this.comment = comment;
        this.author = author;
        this.message = message;
    }

    public Feedback() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getDatePlacement() {
        return datePlacement;
    }

    public void setDatePlacement(Date datePlacement) {
        this.datePlacement = datePlacement;
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

    //Возвращаем строку, т.к. иначе возвращаемое число идет через запятую, а для корректых расчетов нужно через точку.
    public String getPercent() {
        return Float.toString(percent);
    }

    public void setPercent(float percent) {
        this.percent = percent;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public Deal getMessage() {
        return message;
    }

    public void setMessage(Deal message) {
        this.message = message;
    }

    public String getAuthorName() {
        return author != null ? author.getUsername() : "<none>";
    }

    public String getAuthorAvatar() {
        return author != null ? author.getAvatar() : null;
    }
}
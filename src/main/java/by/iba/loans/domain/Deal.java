package by.iba.loans.domain;

import org.hibernate.annotations.Parent;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.Date;

@Entity
public class Deal {
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
    private boolean active;//активно ли объявление
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User author;

    public Deal() {
    }

    public Deal(Long id,
                Date datePlacement,
                int amount,
                int period,
                float percent,
                String comment,
                boolean active,
                User author) {
        this.id = id;
        this.datePlacement = datePlacement;
        this.amount = amount;
        this.period = period;
        this.percent = percent;
        this.comment = comment;
        this.active = active;
        this.author = author;
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

    public Date getDatePlacement() {
        return datePlacement;
    }

    public void setDatePlacement(Date datePlacement) {
        this.datePlacement = datePlacement;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getAuthorName() {
        return author != null ? author.getUsername() : "<none>";
    }

    public String getAuthorAvatar() {
        return author != null ? author.getAvatar() : null;
    }

}

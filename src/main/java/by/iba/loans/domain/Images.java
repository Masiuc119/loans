package by.iba.loans.domain;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;

@Entity
public class Images {
    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Long id;
    @NotBlank
    private String image;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "deal_id")
    private Deal message;

    public Images() {
    }

    public Images(@NotBlank String image, Deal message) {
        this.image = image;
        this.message = message;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Deal getMessage() {
        return message;
    }

    public void setMessage(Deal message) {
        this.message = message;
    }
}

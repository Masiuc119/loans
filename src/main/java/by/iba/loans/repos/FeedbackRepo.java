package by.iba.loans.repos;

import by.iba.loans.domain.Deal;
import by.iba.loans.domain.Feedback;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface FeedbackRepo extends CrudRepository<Feedback, Long> {
    List<Feedback> findByMessage(Deal message);
    int countByMessage(Deal deal);
}

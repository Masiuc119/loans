package by.iba.loans.repos;

import by.iba.loans.domain.Deal;
import by.iba.loans.domain.Message;
import by.iba.loans.domain.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface DealRepo extends CrudRepository<Deal, Long> {
    List<Deal> findByAuthor(User author);
}

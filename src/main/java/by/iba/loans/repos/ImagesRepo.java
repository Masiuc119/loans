package by.iba.loans.repos;

import by.iba.loans.domain.Deal;
import by.iba.loans.domain.Images;
import by.iba.loans.domain.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ImagesRepo extends CrudRepository<Images, Long> {
    List<Images> findByMessage(Deal message);
}

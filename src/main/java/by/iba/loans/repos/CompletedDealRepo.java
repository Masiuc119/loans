package by.iba.loans.repos;

import by.iba.loans.domain.CompletedDeal;
import by.iba.loans.domain.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface CompletedDealRepo extends CrudRepository<CompletedDeal, Long> {
    List<CompletedDeal> findByLender(User lender);
    List<CompletedDeal> findByBorrower(User borrower);
}

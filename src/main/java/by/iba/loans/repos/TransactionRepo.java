package by.iba.loans.repos;

import by.iba.loans.domain.CompletedDeal;
import by.iba.loans.domain.Transaction;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface TransactionRepo extends CrudRepository<Transaction, Long> {
    List<Transaction> findByCompletedDeal(CompletedDeal completedDeal);
}

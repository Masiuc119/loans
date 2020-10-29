package by.iba.loans.service;

import by.iba.loans.domain.Deal;
import by.iba.loans.repos.DealRepo;
import by.iba.loans.repos.FeedbackRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DealService {
    @Autowired
    FeedbackRepo feedbackRepo;
    @Autowired
    DealRepo dealRepo;
    public int countFeedbackForDeal(long id){
        Deal deal = dealRepo.findById(id).get();
        return feedbackRepo.countByMessage(deal);
    }
}

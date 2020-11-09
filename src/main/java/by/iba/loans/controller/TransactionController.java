package by.iba.loans.controller;

import by.iba.loans.domain.CompletedDeal;
import by.iba.loans.domain.Transaction;
import by.iba.loans.domain.User;
import by.iba.loans.repos.CompletedDealRepo;
import by.iba.loans.repos.TransactionRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import javax.validation.Valid;
import java.util.Date;
import java.util.Map;

@Controller
public class TransactionController {
    @Autowired
    private TransactionRepo transactionRepo;

    @Autowired
    private CompletedDealRepo completedDealRepo;

    @PostMapping("/addTransaction/{completedDealId}")
    public String add(@AuthenticationPrincipal User user,
                      @Valid Transaction transaction,
                      BindingResult bindingResult,
                      Model model,
                      @PathVariable String completedDealId) {
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errorsMap);
            model.addAttribute("transaction", transaction);
        } else {
            transaction.setAuthor(user);
            transaction.setCompletedDeal(completedDealRepo.findById(Long.parseLong(completedDealId)).get());
            transaction.setDate(new Date());
            transactionRepo.save(transaction);
        }
        return "redirect:/user/profileEdit";
    }

    @PostMapping("/setTransaction/{transactionId}")
    public String add(@AuthenticationPrincipal User user,
                      @PathVariable String transactionId) {
        Transaction transaction = transactionRepo.findById(Long.parseLong(transactionId)).get();
        CompletedDeal completedDeal = transaction.getCompletedDeal();
        int restDay = (int) (transaction.getDate().getTime() - completedDeal.getDate().getTime()) / 86400000;
        float percentOld = (completedDeal.getPercent() / 30 * restDay) / 100;
        float percent = 1 - (1 / (1 + percentOld));
        int amount = transaction.getAmount() - (int) (transaction.getAmount() * percent);
        int newAmount = completedDeal.getAmount() - amount;
        completedDeal.setAmount(newAmount);
        if (completedDeal.getAmount() <= 0) {
            completedDeal.setActive(false);
        }
        completedDealRepo.save(completedDeal);
        transactionRepo.delete(transaction);
        return "redirect:/user/profileEdit";
    }
}

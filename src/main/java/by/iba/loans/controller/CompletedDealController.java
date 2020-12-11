package by.iba.loans.controller;

import by.iba.loans.domain.*;
import by.iba.loans.repos.CompletedDealRepo;
import by.iba.loans.repos.DealRepo;
import by.iba.loans.repos.FeedbackRepo;
import by.iba.loans.repos.ImagesRepo;
import by.iba.loans.service.MailSender;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.validation.Valid;
import java.util.Date;
import java.util.Map;

import static by.iba.loans.domain.StatusDeal.CONFIRMBORROWER;

@Controller
public class CompletedDealController {
    @Autowired
    private CompletedDealRepo completedDealRepo;
    @Autowired
    private FeedbackRepo feedbackRepo;
    @Autowired
    private DealRepo dealRepo;
    @Autowired
    private ImagesRepo imagesRepo;
    @Autowired
    private MailSender mailSender;

    @GetMapping("/makeDeal/{feedbackId}")
    public String completedDeal(Model model, @PathVariable Long feedbackId) {
        Feedback feedback = feedbackRepo.findById(feedbackId).get();
        Deal deal = feedback.getMessage();
        Iterable<Images> imagess = imagesRepo.findAll();
        model.addAttribute("deal", deal);
        model.addAttribute("imagess", imagess);
        model.addAttribute("feedback", feedback);
        return "makeDealId";
    }

    @PostMapping("/makeDeal")
    public String add(@AuthenticationPrincipal User user,
                      @Valid CompletedDeal completedDeal,
                      BindingResult bindingResult,
                      Model model,
                      @RequestParam("deal_id") String dealId,
                      @RequestParam("feedback_id") String feedbackId) {
        completedDeal.setDate(new Date());
        completedDeal.setActive(true);
        completedDeal.setStatusDeal(CONFIRMBORROWER);
        Feedback feedback = feedbackRepo.findById(Long.parseLong(feedbackId)).get();
        Deal deal = dealRepo.findById(Long.parseLong(dealId)).get();
        completedDeal.setBorrower(deal.getAuthor());
        completedDeal.setLender(feedback.getAuthor());
        completedDeal.setDeal(deal);
        completedDeal.setFeedback(feedback);
        completedDeal.setPercent(Float.parseFloat(feedback.getPercent()));
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errorsMap);
            model.addAttribute("completedDeal", completedDeal);
        } else {
            if (deal.getAuthor().getId().equals(user.getId())) {
                completedDealRepo.save(completedDeal);
                completedDeal.getDeal().setActive(false);
                if (!StringUtils.isEmpty(feedback.getAuthor().getEmail())) {
                    String message = String.format(
                            "Здравствуйте, %s! \n" +
                                    "Ваш отклик на получение займа приняли. Для просмотра информации посетите Ваш личный кабинет: http://localhost:8080/user/profileEdit",
                            feedback.getAuthor().getUsername()
                    );
                    mailSender.send(feedback.getAuthor().getEmail(), "Ваш отклик приняли", message);
                }
            }
            model.addAttribute("completedDeal", null);
        }
        return "redirect:/deal";
    }

    @PostMapping("/setStatusCompDeal/{completedDealId}")
    public String setStatus(@AuthenticationPrincipal User user,
                            @PathVariable Long completedDealId,
                            @RequestParam("statusCompDeal") StatusDeal statusDeal) {
        CompletedDeal completedDeal = completedDealRepo.findById(completedDealId).get();
        if ((statusDeal.equals(StatusDeal.CONFIRMLENDER) || statusDeal.equals(StatusDeal.TRANSFERMONEY)) && user.getId().equals(completedDeal.getLender().getId())) {
            completedDeal.setStatusDeal(statusDeal);
            completedDeal.setDate(new Date());
            completedDealRepo.save(completedDeal);
            if (!StringUtils.isEmpty(completedDeal.getBorrower().getEmail())) {
                String message = String.format(
                        "Здравствуйте, %s! \n" +
                                "Изменился статус одного из Ваших займов. Для просмотра информации посетите Ваш личный кабинет: http://localhost:8080/user/profileEdit",
                        completedDeal.getBorrower().getUsername()
                );
                mailSender.send(completedDeal.getBorrower().getEmail(), "Изменился статус займа", message);
            }
        }
        if (statusDeal.equals(StatusDeal.RECEIVEMONEY) && user.getId().equals(completedDeal.getBorrower().getId())) {
            completedDeal.setStatusDeal(statusDeal);
            completedDeal.setDate(new Date());
            completedDealRepo.save(completedDeal);
            if (!StringUtils.isEmpty(completedDeal.getLender().getEmail())) {
                String message = String.format(
                        "Здравствуйте, %s! \n" +
                                "Изменился статус одного из Ваших займов. Для просмотра информации посетите Ваш личный кабинет: http://localhost:8080/user/profileEdit",
                        completedDeal.getLender().getUsername()
                );
                mailSender.send(completedDeal.getLender().getEmail(), "Изменился статус займа", message);
            }
        }
        return "redirect:/user/profileEdit";
    }
}

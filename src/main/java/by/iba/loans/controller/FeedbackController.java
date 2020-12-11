package by.iba.loans.controller;

import by.iba.loans.domain.Deal;
import by.iba.loans.domain.Feedback;
import by.iba.loans.domain.Images;
import by.iba.loans.domain.User;
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

import javax.validation.Valid;
import java.util.*;

@Controller
public class FeedbackController {
    @Autowired
    private FeedbackRepo feedbackRepo;
    @Autowired
    private DealRepo dealRepo;
    @Autowired
    private ImagesRepo imagesRepo;
    @Autowired
    private MailSender mailSender;

    @GetMapping("/deal/{dealId}")
    public String dealId(@AuthenticationPrincipal User user, Model model, @PathVariable String dealId) {
        Optional<Deal> deal = dealRepo.findById(Long.parseLong(dealId));
        Iterable<Images> imagess = imagesRepo.findByMessage(deal.get());
        Iterable<Feedback> feedbacks = feedbackRepo.findByMessage(deal.get());
        boolean isNew = true;
        model.addAttribute("isNew", isNew);
        model.addAttribute("feedbacks", feedbacks);
        model.addAttribute("deal", deal.get());
        model.addAttribute("imagess", imagess);
        return "dealId";
    }

    @PostMapping("/deal/newFeedback/{dealId}")
    public String add(
            @AuthenticationPrincipal User user,
            @Valid Feedback feedback,
            BindingResult bindingResult,
            Model model,
            @PathVariable String dealId) {
        feedback.setAuthor(user);
        feedback.setDatePlacement(new Date());
        Deal deal = dealRepo.findById(Long.parseLong(dealId)).get();
        feedback.setMessage(deal);
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errorsMap);
            model.addAttribute("feedback", feedback);
        } else {
            feedbackRepo.save(feedback);
            if (!StringUtils.isEmpty(deal.getAuthor().getEmail())) {
                String message = String.format(
                        "Здравствуйте, %s! \n" +
                                "На Вашу заявку в системе управления финансовыми микрозаймами добавлен новый отклик. Для просмотра пройдите пожалуйста по ссылке: http://localhost:8080/deal/viewFeedbacks/%s",
                        deal.getAuthor().getUsername(),
                        deal.getId()
                );
                mailSender.send(deal.getAuthor().getEmail(), "Новый отклик", message);
            }
            model.addAttribute("feedback", null);
        }
        boolean isNew = false;
        model.addAttribute("isNew", isNew);
        Iterable<Images> imagess = imagesRepo.findByMessage(deal);
        Iterable<Feedback> feedbacks = feedbackRepo.findByMessage(deal);
        model.addAttribute("feedbacks", feedbacks);
        model.addAttribute("deal", deal);
        model.addAttribute("imagess", imagess);
        return "dealId";
    }
    @GetMapping("/deal/viewFeedbacks/{dealId}")
    public String viewDealId(@AuthenticationPrincipal User user, Model model, @PathVariable String dealId) {
        Optional<Deal> deal = dealRepo.findById(Long.parseLong(dealId));
        Iterable<Images> imagess = imagesRepo.findByMessage(deal.get());
        Iterable<Feedback> feedbacks = feedbackRepo.findByMessage(deal.get());
        boolean isNew = false;
        model.addAttribute("isNew", isNew);
        model.addAttribute("feedbacks", feedbacks);
        model.addAttribute("deal", deal.get());
        model.addAttribute("imagess", imagess);
        return "dealId";
    }

    @GetMapping("/deal/editFeedback/{feedbackId}")
    public String feedbackEdit(@AuthenticationPrincipal User user, Model model, @PathVariable String feedbackId) {
        Optional<Feedback> feedback = feedbackRepo.findById(Long.parseLong(feedbackId));
        Iterable<Images> imagess = imagesRepo.findByMessage(feedback.get().getMessage());
        if (user.isAdmin() || user.isModerator() || Objects.equals(user.getId(), feedback.get().getAuthor().getId())) {
            Deal deal = feedback.get().getMessage();
            boolean isNew = true;
            model.addAttribute("isNew", isNew);
            model.addAttribute("deal", deal);
            model.addAttribute("feedbackEdit", feedback.get());
            model.addAttribute("imagess", imagess);
            return "dealId";
        }
        return "redirect:/deal/"+ feedback.get().getMessage().getId();
    }

    @PostMapping("/deal/editFeedback/{feedbackId}")
    public String feedbackUpdate(
            @AuthenticationPrincipal User user,
            @Valid Feedback feedback,
            BindingResult bindingResult,
            Model model,
            @PathVariable String feedbackId
    ) {
        Feedback feedbackNew = feedbackRepo.findById(Long.parseLong(feedbackId)).get();
        feedbackNew.setAmount(feedback.getAmount());
        feedbackNew.setComment(feedback.getComment());
        feedbackNew.setPeriod(feedback.getPeriod());
        feedbackNew.setPercent(Float.parseFloat(feedback.getPercent()));
        feedbackRepo.save(feedbackNew);
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);

            model.mergeAttributes(errorsMap);
            model.addAttribute("feedback", feedback);
        } else {

                model.addAttribute("feedback", null);

        }
        return "redirect:/deal/viewFeedbacks/"+ feedbackNew.getMessage().getId();
    }
}

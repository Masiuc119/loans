package by.iba.loans.controller;

import by.iba.loans.domain.Deal;
import by.iba.loans.domain.Feedback;
import by.iba.loans.domain.Images;
import by.iba.loans.domain.User;
import by.iba.loans.repos.DealRepo;
import by.iba.loans.repos.FeedbackRepo;
import by.iba.loans.repos.ImagesRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
        Optional<Deal> deal = dealRepo.findById(Long.parseLong(dealId));
        feedback.setMessage(deal.get());
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errorsMap);
            model.addAttribute("feedback", feedback);
        } else {
            feedbackRepo.save(feedback);
            model.addAttribute("feedback", null);
        }
        Iterable<Images> imagess = imagesRepo.findByMessage(deal.get());
        Iterable<Feedback> feedbacks = feedbackRepo.findByMessage(deal.get());
        model.addAttribute("feedbacks", feedbacks);
        model.addAttribute("deal", deal.get());
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

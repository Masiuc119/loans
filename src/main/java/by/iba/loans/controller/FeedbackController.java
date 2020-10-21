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
import java.util.Date;
import java.util.Map;
import java.util.Optional;

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
}

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
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.validation.Valid;
import java.util.*;

@Controller
public class DealController {
    @Autowired
    private DealRepo dealRepo;
    @Autowired
    private ImagesRepo imagesRepo;
    @Autowired
    private FeedbackRepo feedbackRepo;

    @GetMapping("/deal")
    public String deal(Model model) {
        Iterable<Deal> deals = dealRepo.findAll();
        Iterable<Images> imagess = imagesRepo.findAll();
        Iterable<Feedback> feedbacks = feedbackRepo.findAll();
        model.addAttribute("deals", deals);
        model.addAttribute("imagess", imagess);
        model.addAttribute("feedbacks", feedbacks);
        return "deal";
    }

    @PostMapping("/deal")
    public String add(
            @AuthenticationPrincipal User user,
            @Valid Deal deal,
            BindingResult bindingResult,
            Model model,
            @RequestParam("file") String file
    ){
        deal.setAuthor(user);
        deal.setDatePlacement(new Date());
        deal.setActive(true);

        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errorsMap);
            model.addAttribute("deal", deal);
        } else {
            dealRepo.save(deal);
            if (!StringUtils.isEmpty(file)) {
                Images image = new Images();
                image.setImage(file);
                image.setMessage(deal);
                imagesRepo.save(image);
            }
            model.addAttribute("deal", null);
        }
        Iterable<Deal> deals = dealRepo.findAll();
        Iterable<Images> imagess = imagesRepo.findAll();
        Iterable<Feedback> feedbacks = feedbackRepo.findAll();
        model.addAttribute("deals", deals);
        model.addAttribute("imagess", imagess);
        model.addAttribute("feedbacks", feedbacks);
        return "deal";
    }

    @GetMapping("/deal/edit/{dealId}")
    public String dealEdit(@AuthenticationPrincipal User user, Model model, @PathVariable String dealId) {
        Optional<Deal> deal = dealRepo.findById(Long.parseLong(dealId));
        if (user.isAdmin() || user.isModerator() || Objects.equals(user.getId(), deal.get().getAuthor().getId())) {
            Iterable<Images> imagess = imagesRepo.findAll();
            model.addAttribute("deal", deal.get());
            model.addAttribute("imagess", imagess);
            return "dealEdit";
        }
        return "redirect:/deal";
    }

    @PostMapping("/deal/edit/{dealId}")
    public String dealUpdate(
            @AuthenticationPrincipal User user,
            @Valid Deal deal,
            BindingResult bindingResult,
            Model model,
            @RequestParam("file") String file,
            @PathVariable String dealId
    ) {
        Deal dealNew = dealRepo.findById(Long.parseLong(dealId)).get();
        dealNew.setAmount(deal.getAmount());
        dealNew.setComment(deal.getComment());
        dealNew.setPeriod(deal.getPeriod());
        dealNew.setPercent(Float.parseFloat(deal.getPercent()));
        dealRepo.save(dealNew);
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);

            model.mergeAttributes(errorsMap);
            model.addAttribute("deal", deal);
        } else {
            if (!StringUtils.isEmpty(file)) {
                List<Images> imagesList = imagesRepo.findByMessage(deal);
                if (imagesList.isEmpty()) {
                    Images image = new Images();
                    image.setImage(file);
                    image.setMessage(deal);
                    imagesRepo.save(image);
                } else {
                    Images image = imagesList.get(0);
                    image.setImage(file);
                    imagesRepo.save(image);
                }
                model.addAttribute("deal", null);
            }
        }
        return "redirect:/deal";
    }

    @GetMapping("/deal/disable/{dealId}")
    public String dealDisable(@AuthenticationPrincipal User user, Model model, @PathVariable String dealId) {
        Optional<Deal> deal = dealRepo.findById(Long.parseLong(dealId));
        if (user.isAdmin() || Objects.equals(user.getId(), deal.get().getAuthor().getId())) {
            deal.get().setActive(false);
        }
        return "redirect:/deal";
    }
}

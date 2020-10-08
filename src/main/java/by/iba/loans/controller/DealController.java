package by.iba.loans.controller;

import by.iba.loans.domain.Deal;
import by.iba.loans.domain.Images;
import by.iba.loans.domain.Message;
import by.iba.loans.domain.User;
import by.iba.loans.repos.DealRepo;
import by.iba.loans.repos.ImagesRepo;
import freemarker.template.utility.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.validation.Valid;
import java.io.IOException;
import java.util.Date;
import java.util.Map;

@Controller
public class DealController {
    @Autowired
    private DealRepo dealRepo;
    @Autowired
    private ImagesRepo imagesRepo;

    @GetMapping("/deal")
    public String deal(Model model) {

        Iterable<Deal> deals = dealRepo.findAll();
        Iterable<Images> imagess = imagesRepo.findAll();
        model.addAttribute("deals", deals);
        model.addAttribute("imagess", imagess);
        return "deal";
    }

    @PostMapping("/deal")
    public String add(
            @AuthenticationPrincipal User user,
            @Valid Deal deal,
            BindingResult bindingResult,
            Model model,
            @RequestParam("file") String file
    ) throws IOException {
        deal.setAuthor(user);
        deal.setDatePlacement(new Date());
        deal.setActive(true);
        dealRepo.save(deal);
        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = ControllerUtils.getErrors(bindingResult);

            model.mergeAttributes(errorsMap);
            model.addAttribute("deal", deal);
        } else {
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

        model.addAttribute("deals", deals);
        model.addAttribute("imagess", imagess);

        return "deal";
    }
}

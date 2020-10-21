package by.iba.loans.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Map;

@Controller
public class MainController {
    @GetMapping("/")
    public String loans(Map<String, Object> model) {
        return "home";
    }
}

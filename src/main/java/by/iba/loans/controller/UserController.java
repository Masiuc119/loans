package by.iba.loans.controller;

import by.iba.loans.domain.CompletedDeal;
import by.iba.loans.domain.Role;
import by.iba.loans.domain.StatusDeal;
import by.iba.loans.domain.User;
import by.iba.loans.repos.CompletedDealRepo;
import by.iba.loans.service.UserSevice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


import java.util.Date;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserSevice userSevice;
    @Autowired
    private CompletedDealRepo completedDealRepo;
    @PreAuthorize("hasAuthority('ADMIN')")
    @GetMapping
    public String userList(Model model) {
        model.addAttribute("users", userSevice.findAll());

        return "userList";
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    @GetMapping("{user}")
    public String userEditForm(@PathVariable User user, Model model) {
        model.addAttribute("user", user);
        model.addAttribute("roles", Role.values());

        return "userEdit";
    }

    @PreAuthorize("hasAuthority('ADMIN')")
    @PostMapping
    public String userSave(
            @RequestParam String username,
            @RequestParam Map<String, String> form,
            @RequestParam("userId") User user
    ) {
        userSevice.saveUser(user, username, form);

        return "redirect:/user";
    }

    @GetMapping("profileEdit")
    public String getProfile(Model model, @AuthenticationPrincipal User user) {
        model.addAttribute("avatar", user.getAvatar());
        model.addAttribute("username", user.getUsername());
        model.addAttribute("email", user.getEmail());
        Iterable<CompletedDeal> completedDealLender = completedDealRepo.findByLender(user);
        Iterable<CompletedDeal> completedDealBorrower = completedDealRepo.findByBorrower(user);
        Date date = new Date();
        model.addAttribute("user", user);
        model.addAttribute("completedDealLender", completedDealLender);
        model.addAttribute("completedDealBorrower", completedDealBorrower);
        model.addAttribute("date", date);
        return "profile";
    }

    @PostMapping("profileEdit")
    public String updateProfile(
            @AuthenticationPrincipal User user,
            @RequestParam String file,
            @RequestParam String password,
            @RequestParam String email
    ) {
        userSevice.updateProfile(user, file, password, email);
//Перелогиниваемся для применения изменений к текущей сессии
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Authentication newAuth = new UsernamePasswordAuthenticationToken(auth.getPrincipal(), auth.getCredentials(), auth.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(newAuth);
        return "redirect:/user/profileEdit";
    }
}

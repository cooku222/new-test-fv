package com.khtml.oti.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {

    @GetMapping("/login")
    public String sayHello() {
        return "Hello from Spring Boot!";
    }
}

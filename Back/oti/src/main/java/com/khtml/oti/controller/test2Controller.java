package com.khtml.oti.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/")
public class test2Controller {

    @GetMapping
    public ResponseEntity<Map<String, String>> check() {
        Map<String, String> response = new HashMap<>();
        response.put("body", "GET request received at /main");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

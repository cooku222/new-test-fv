package com.khtml.oti.controller;

import com.khtml.oti.model.DTO.ResponseTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/main")
public class testController {

    @GetMapping(value = "/test",  produces = "application/xml")
    public ResponseEntity<ResponseTest> check() {
        ResponseTest res = new ResponseTest("This is a test message", 200);
        return ResponseEntity
                .status(HttpStatus.OK)
                .contentType(MediaType.APPLICATION_JSON)
                .body(res);
    }
}

package com.khtml.oti.controller;

import com.khtml.oti.model.DTO.RequestSTT;
import com.khtml.oti.model.DTO.ResponseTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(("/myhomepage"))
public class PathController {
    RequestSTT requestSTT;

    @PostMapping
    public void getText(@RequestBody RequestSTT req) {
        // 요청에서 받은 데이터를 기반으로 응답 생성
        requestSTT = req;

        // message를 출력
        System.out.println(req.text);
        return ;
    }

    @GetMapping
    public ResponseEntity<ResponseTest> sendText() {
        ResponseTest res = new ResponseTest("This is a openai API message", 200);
        return ResponseEntity
                .status(HttpStatus.OK)
                .contentType(MediaType.APPLICATION_JSON)
                .body(res);
    }
}

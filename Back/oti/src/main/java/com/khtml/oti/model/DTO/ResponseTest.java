package com.khtml.oti.model.DTO;

import lombok.Data;

@Data
public class ResponseTest {
    public String message;
    public int statusCode;

    public ResponseTest(String message, int statusCode) {
        this.message = message;
        this.statusCode = statusCode;
    }
}

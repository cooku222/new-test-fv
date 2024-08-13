package com.khtml.oti.model.DTO;

import lombok.Data;

@Data
public class RequestSTT {
    public String text;

    public RequestSTT() {}

    public RequestSTT(String text) {
        this.text = text;
    }
}

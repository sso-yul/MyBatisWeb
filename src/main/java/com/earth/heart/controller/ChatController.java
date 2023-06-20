package com.earth.heart.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatController {
	
	@GetMapping(value = "/chat")
	public String chat(HttpServletRequest req, HttpServletResponse rep, HttpSession session) {
		return "chat";
	}
}

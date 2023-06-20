package com.earth.heart.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.earth.heart.domain.Person;

@Controller
public class RestfulController {

	@GetMapping("/ajax")
	public String ajax() {
		return "ajax";
	}
	
	
	//send 버튼 눌렀을 때 url주소로 이 메서드를 줄 것
	//@RequestBody 는 매핑 역할
	//@ResponseBody 메서드를 실행한 후 결과를 HTTP 응답에 담아 전달해주는 역할
	@PostMapping("/send")
	@ResponseBody
	public Person test(@RequestBody Person p) {
		//person 안에 일단 name과 age가 들어있음
		//p 출력 시 toString이 나옴
		System.out.println("p = " + p);
		p.setName("earth0630");
		//원래 담겨있는 값 10에 2023을 더함
		p.setAge(p.getAge() + 2023);
		return p;
	}
	
	//처음 화면 요청 - test
	@GetMapping("/test")
	public String test() {
		return "test";		//page(view) jsp
	}
	
	
}

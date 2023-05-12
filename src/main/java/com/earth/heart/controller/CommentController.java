package com.earth.heart.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.earth.heart.domain.CommentDTO;
import com.earth.heart.service.CommentService;

@Controller
public class CommentController {
	
	@Autowired
	CommentService service;
		
	//댓글은 목록이니 List
	//지정된 게시물의 모든 댓글을 가져오는 메서드
	//29. Ajax & Restful API 노트 참고
	//Generic이 List<CommentDTO>인 이유는 리스트 값 뿐 아니라 상태 코드 값도 같이 넘기기 위해서이다
	//HttpStatus.OK 는 ResponseEntity API 확인
	@GetMapping("/comments")
	@ResponseBody
	public ResponseEntity<List<CommentDTO>> list(Integer bno) {
				
		//CommentService에서 getList 불러와야 한다
		List<CommentDTO> list = null;
		
		try {
			list = service.getList(bno);
			return new ResponseEntity<List<CommentDTO>>(list, HttpStatus.OK);
		} catch (Exception e) {
			//예외발생... getList로 넘어가서 시겨줌
			e.printStackTrace();
			return new ResponseEntity<List<CommentDTO>>(HttpStatus.BAD_REQUEST);
		}
		//@ResponseBody가 되었으니 이건 페이지가 아니라 현재 있는 댓글을 데이터로 던져 보내주는 거
		//http://localhost/heart/comments?bno=8 하면 데이터 들어갔는지 아닌지 확인 가능
		//return list;
	}

	
}

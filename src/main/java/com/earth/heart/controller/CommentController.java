package com.earth.heart.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.earth.heart.domain.CommentDTO;
import com.earth.heart.service.CommentService;

@Controller
public class CommentController {
	
	@Autowired
	CommentService service;
	
	//댓글 수정
	//댓글의 uri가 Path되니까 어노테이션 추가, 댓글 추가, 아이디 값 받기
	@PatchMapping("/comments/{cno}")
	public ResponseEntity<String> modify(@PathVariable Integer cno, @RequestBody CommentDTO dto, HttpSession session) {
		String commenter = (String)session.getAttribute("id");
		
		//dto의 커멘터를 설정
		dto.setCommenter(commenter);
		//cno도 board.jsp단에서 파라미터로 넘어옴
		dto.setCno(cno);
		
		try {		//항상 불러오는 메서드가 뭔지 ... 확인하기
			if(service.modify(dto) != 1) {
				throw new Exception("Update Failed");
			}
			return new ResponseEntity<String>("MODIFY_OK", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("MODIFY_ERROR", HttpStatus.BAD_REQUEST);
		}
		
	}
	
	
	//댓글 작성
	//해당 바디의 댓글 내용이 넘어가야하니 리퀘스트 바디, 그리고 게시글 숫자 필요하니 bno, 작성자 넘겨야하니 세션
	@PostMapping("/comments")
	public ResponseEntity<String> write(@RequestBody CommentDTO dto, Integer bno, HttpSession session) {
		String commenter = (String)session.getAttribute("id");
		
		//dto의 커멘터를 설정
		dto.setCommenter(commenter);
		//bno도 board.jsp단에서 파라미터로 넘어옴
		dto.setBno(bno);
		System.out.println("dto = " + dto);
		
		try {
			if(service.write(dto) != 1) {
				throw new Exception("Write Failed");
			}
			return new ResponseEntity<String>("WRITE_OK", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("WRITE_ERROR", HttpStatus.BAD_REQUEST);
		}
	}
	
	//댓글이 된 DTO가 타입이 되어야 함
	//해당(지정된) 댓글 삭제 
	//ID 저장을 session에 해놓으니 세선도 가져옴(아이디 확인해서 작성자만 삭제가능하게 해야하니까)
	//1-1 bno 매핑 됐듯 cno도 매핑 되어야 하는데 (댓글은 cno의 값이 항상 바뀌니) bno처럼 알아서 매핑이 안 되니 이거 우찌 선택할겨
	//1-2 annotation 넣어줌 @PathVariable
	//bno는 겟방식으로 넘어가서 안 해줘도 됨
	@DeleteMapping("/comments/{cno}")
	public ResponseEntity<String> remove(@PathVariable Integer cno, Integer bno, HttpSession session) {
		String commenter = (String)session.getAttribute("id");
		//이 안에서 cno활용해서 Service 단으로 넘기면 됨 (서비스 다오)
		try {
			int rowCnt = service.remove(cno, bno, commenter);
			//rowCnt가 1이면 정상처리 아니면 예외처리
			if(rowCnt != 1) {
				throw new Exception("Delete Failed");
			}
			
			return new ResponseEntity<>("DELETE_OK", HttpStatus.OK);		//정상 실행 케이스
		} catch (Exception e) {
			e.printStackTrace();											//비정상 실행 케이스
			return new ResponseEntity<String>("DELETE_ERROR", HttpStatus.BAD_REQUEST);
		}

	}
		
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

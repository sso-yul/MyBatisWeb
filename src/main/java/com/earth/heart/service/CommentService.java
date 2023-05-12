package com.earth.heart.service;

import java.util.List;

import com.earth.heart.domain.CommentDTO;

public interface CommentService {

	//특정 bno에 대한 댓글 리스트
	List<CommentDTO> getList(Integer bno) throws Exception;
	
	//삭제 댓글번호, 댓글의 게시글(부모), 작성자
	int remove(Integer cno, Integer bno, String commenter) throws Exception;
	
	//삽입 - 댓글 작성
	int write(CommentDTO commentDTO) throws Exception;
	
	//수정
	int modify(CommentDTO commentDTO) throws Exception;
}

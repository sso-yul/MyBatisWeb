package com.earth.heart.dao;

import java.util.List;

import com.earth.heart.domain.CommentDTO;

public interface CommentDao {
	
	//특정 게시물의 댓글 개수 세기
	int count(Integer bno) throws Exception; 
	
	//특정 게시물의 댓글 전부 삭제
	int deleteAll(Integer bno) throws Exception;
	
	//작성자가 일치할 경우 한 게시글에서 특정 댓글 삭제하게 함
	int delete(Integer cno, String commenter) throws Exception;
	
	//특정 bno의 댓글만 selectAll 파라미터 타입은 int resultType은 CommentDTO,따라서 리턴 타입은 List<>
	List<CommentDTO> selectAll(Integer bno) throws Exception;
	
	//댓글 추가
	int insert(CommentDTO commentDTO) throws Exception;
	
	//댓글 수정(업데이트) 파라미터 타입 CommentDTO
	int update(CommentDTO commentDTO) throws Exception;
	
	
}

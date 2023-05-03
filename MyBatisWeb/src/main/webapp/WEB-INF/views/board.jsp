<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="loginId" value="${sessionScope.id }" />
<c:set var="loginout" value="${sessionScope.id == null ? 'Login' : 'Logout' }" />
<c:set var="loginoutlink" value="${sessionScope.id == null ? '/login/login' : '/login/logout' }" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
     	<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/menu.css' />" /> 
    
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <title>게시글 조회</title>
    
    <style type="text/css">
    	
    	* {
    		font-family: 'Noto Sans KR', sans-serif;
    	}
    	
    	.container {
    		width: 50%;
    		margin: auto;
    	}
    textarea {
    	width: 800px;
    	height: 500px;
    	resize: none;
    }
    button {
    	border: 1px solid #ab77e6;
    	color: #ab77e6;
  		background-color: transparent;
  		padding: 2px;
  		border-radius: 3px;
    }
    
    </style>
    
    
</head>
<body>
	
	<div id="menu">
    <ul>
    	<li id="logo">earth</li>
    	<li><a href="<c:url value='/' />">Home</a></li>
    	<li><a href="<c:url value='/board/list' />">Board</a></li>
    	<li><a href="<c:url value='${loginoutlink }' />">${loginout }</a></li>
    	<li><a href="<c:url value='/register/add' />">SignUp</a></li>
    	<li><a href="#"><i class="fas fa-search" style="color : #fff;"></i></a></li>
    </ul>
    </div>
	
	<!-- ready 되었을 때 호출되는 콜백 : 자바로 치면 진입점.. 메인 함수와 같음-->
	<script type="text/javascript">
		$(document).ready(function() {
			
		})
	</script>
	
	
	<div class="container">
		<h2>게시판 ${mode=="new" ? "작성" : "읽기"}</h2>
		<form action="" id="form" class="frm" method="post">
			<!-- 페이지페이지 전환 이런 거 할 때는 값을 받아오기 위해 name 속성을 쓴다 -->
			<input type="hidden" name="bno" value="${boardDTO.bno }" />
			<!-- 삼항 연산자 - new로 저장했을 때 참/ 거짓 .... 그리고 뒤에는 인풋 태그 안에 리드온니 속성에 리드온니 타입을 준 것 -->
			<input type="text" name="title" value="${boardDTO.title }" ${mode=="new" ? "" : "readonly = 'readonly'" } />
			<br />
			<textarea rows="20" name="content" ${mode=="new" ? "" : "readonly = 'readonly'" } >${boardDTO.content }</textarea>
			<br />
			
			<!-- mode의 값이 new이냐 아니냐 체크/new이면 수정(등록)이 가능하니 이 조건이 나오면 버튼 나오게 함 ne=not equal  eq = equal-->
			<c:if test="${mode eq 'new' }">
				<button type="button" id="writeBtn" class="btn btn-write"><i class="fas fa-pencil"></i>등록</button>
			</c:if>
			
			<c:if test="${mode eq 'new' }">
				<button type="button" id="writeNewBtn" class="btn btn-write"><i class="fas fa-pencil"></i>작성</button>
			</c:if>
			
			<!-- 작성자와 로그인 아이디가 같을 때만 수정/삭제 가능한 버튼 뜨게 하기 -->
			<c:if test="${boardDTO.writer eq loginId }">
				<button type="button" id="modifyBtn" class="btn btn-write"><i class="fas fa-edit"></i>수정</button>
				<button type="button" id="removeBtn" class="btn btn-write"><i class="fas fa-trash"></i>삭제</button>
			</c:if>
			
			<button type="button" id="listBtn" class="btn btn-list"><i class="fas fa-bars"></i>목록</button>
		</form>
		
		<button type="button" id="sendBtn">SEND</button>
		<button type="button" id="modBtn">수정하기</button>
	</div>
</body>
</html>
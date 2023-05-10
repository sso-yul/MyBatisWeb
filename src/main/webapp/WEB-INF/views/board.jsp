<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="loginId" value="${sessionScope.id }" />
<c:set var="loginout" value="${sessionScope.id == null ? 'Login' : 'id: '+=loginId }" />
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

	    .btn {
	    	border: 1px solid #ab77e6;
	    	font-size: 15px;
	    	color: #ab77e6;
	  		background-color: transparent;
	  		padding: 3px;
	  		border-radius: 3px;
	  		cursor: pointer;
	    }
	    
	    .btn:hover {
	    	text-decoration: none;
	    	background-color: #ab77e6;
	    	color: white;
	    }
	    
	    .writing-header {
	    	position: relative;
	    	margin: 20px 0 0 0;
	    	padding: 10px;
	    	border-bottom: 3px solid #9780ff;
	    }
	    
	    .frm {
	    	width: 100%;
	    }
	    
	    input {
	    	width: 100%;
	    	height: 35ps;
	    	margin:5px 0px 10px 0px;
	    	border: 1px solid #e9e8e8;
	    	padding: 8px;
	    	background: #f8f8f8;
	    	outline-color: #9780ff;
	    }
	    
	    textarea {
	    	width: 100%;
	    	background: #f8f8f8;
	    	margin: 5px 0px 10px 0px;
	    	border: 1px solid #e9e8e8;
	    	resize: none;
	    	padding: 8px;
	    	outline-color: #9780ff;
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
	
	<!-- ready 되었을 때 호출되는 콜백 : 자바로 치면 진입점.. 자바의 메인 함수와 같음(main())-->
	<script type="text/javascript">						//https://api.jquery.com/ 또는 https://developer.mozilla.org/ 여기서 함수 확인
		$(document).ready(function() {
			let bno = $("input[name=bno]").val()		//인풋 태그 안에 속성(네임)의 값(bno)의 value(.val())를 bno에 저장
			
//			$("#listBtn").on("click", function() {		//listBtn에 on(지금은 클릭) 이벤트가 발생했을 때 이런 펑션(함수)이 실행됨
//				alert("listBtn clicked")
//			})
			$("#listBtn").on("click", function() {
				location.href = "<c:url value='/board/list${searchItem.queryString}' />"		//해당 페이지(page= '요부분') 정보로 화면 전환됨
			})
			
			//게시글 삭제
			$("#removeBtn").on("click", function() {	//삭제 버튼 눌렀을 대 일어나는 이벤트 (기능) 함수
				if(!confirm("게시물이 삭제됩니다."))			
					return;						//false면 모달이 꺼지며 원래 화면 그냥 리턴됨
				
				let form = $("#form")					//
				form.attr("action", "<c:url value='/board/remove${searchItem.queryString}' />")			//form의 attribute속성(action)을 추가할 수 있음 참고: https://api.jquery.com/attr/#attr-attributeName-value
				form.attr("method", "post")		//post방식으로 전송
				form.submit()
			})
			
			//게시글 작성
			$("#writeBtn").on("click", function() {	//글작성 버튼 눌렀을 때 일어나는 기능 함수
				let form = $("#form")
				form.attr("action", "<c:url value='/board/write' />")
				form.attr("method", "post")
				
			//제목 또는 내용이 채워졌는지 확인해야함
				if(formCheck()) {
					form.submit()
				}
			})
			let formCheck = function() {
				let form = document.getElementById("form")
				
				//validation 체크(null 인지 아닌지)
				if(form.title.value == "") {
					alert("제목을 입력하세요")
					form.title.focus()
					return false
				}
				if(form.content.value == "") {
					alert("내용을 입력하세요")
					form.content.focus()
					return false
				}
				return true
			}
			
			//게시글 수정
			$("#modifyBtn").on("click", function() {	//수정버튼 눌렀을 때 일어나는 기능 함수
				//readonly 속성 제거
				let form = $("#form")
				let isReadonly = $("input[name=title]").attr('readonly')	//바꾸기 위해 readonly를 저장
				
				//읽기 상태이면 수정 상태로 변경해야 함
				if(isReadonly == 'readonly') {
					$(".writing-header").html("게시판 수정")						//.html 태그를 쓰면 문자열(게시판 수정)로 변경이 가능해짐
					$("input[name=title]").attr('readonly', false)				//input 속성의 값이 title인 것을 찾아 attribute 추가해서 readonly 상태를 false로 설정
					$("textarea").attr('readonly', false)						//textarea 속성의 attribute를 추가해서 readonly 상태를 false로 변경
					$("#modifyBtn").html("<i class='fa-light fa-pencil'></i> 수정하기")	//modifyBtn는 id니까 #이 붙음
					return;
				}
				//화면단에서 수정 했으니 이제 수정상태로 수정된 내용을 서버로 전송해야 함
				form.attr("action","<c:url value='/board/modify${searchItem.queryString}' />")
				form.attr("method", "post")
				if(formCheck()) {
					form.submit()
				}	//여기까지 오면 BoardController의 modify로 이동해서 처리됨
			})

		})
	</script>
	
	<script type="text/javascript">
		//게시물 등록 실패
		let msg = "${msg}"
		if(msg == "WRITE_ERROR")
			alert("게시물 등록에 실패했습니다. 다시 시도해 주세요")
		if(msg == "MODE_ERROR")
			alert("게시물 수정에 실패했습니다. 다시 시도해 주세요")
	</script>
	
	<div class="container">
		<h2 class="writing-header">게시판 ${mode=="new" ? "작성" : "읽기"}</h2>
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
			
			<c:if test="${mode ne 'new' }">
				<button type="button" id="writeNewBtn" class="btn btn-write"><i class="fas fa-pencil-alt"></i>작성</button>
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
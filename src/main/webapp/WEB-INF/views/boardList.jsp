<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!--loginId에 sessionScope.id가 저장되어 있음  -->
<c:set var="loginId" value="${sessionScope.id }" />
<c:set var="loginout" value="${sessionScope.id == null ? 'Login' : 'id: '+=loginId }" />
<c:set var="loginoutlink" value="${sessionScope.id == null ? '/login/login' : '/login/logout' }" />


<!DOCTYPE html>
<html lang="ko">
<head>
 	<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/menu.css' />" /> 
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <title>게시판 리스트</title>
    
    <style type="text/css">
    	*{
    		font-family: 'Noto Sans KR', sans-serif;
    	}
    	
    	a {
    		text-decoration: none;
    		color: black;
    	}
    	
    	button, input {
	    	border: none;
	    	outline: none;
	    }	
    	
    	.board-container {
    		width: 60%;
    		height: 800px;
    		margin: 0 auto;
    	}
    	
    	.search-container {
	    	background-color: rgb(253, 253, 250);
	    	width: 100%;
	    	height: 110px;
	    	border: 1px solid #ddd;
	    	margin-top: 10px;
	    	margin-bottom: 30px;
	    	display: flex;
	    	justify-content: center;
	    	align-items: center;
	    }
	    
	    table {
	    	border-collapse: collapse;
	    	width: 100%;
	    	border-top: 2px solid #9780ff;
	    }
	    
	    <!-- 짝수 색깔 -->
	    tr:nth-child(even) {
			background-color: #f0f0f070;
		}
	    
	    th,td {
	    	width: 300px;
	    	text-align: center;
	    	padding: 10px 12px;
	    	border-bottom: 1px solid #ddd;
	    }
	    
	    .paging-container {
	    	width: 100%;
	    	height: 70px;
	    	display: flex;
	    	margin-top: 50px;
	    	margin: auto;
	    }
	    
	    .paging{
	    	color: black;
	    	width: 100%;
	    	align-items: center;
	    }
	    
	    .page {
	    	color: black;
	    	padding: 6px;
	    	margin-right: 10px;
	    }
	    
	    .search-form {
	    	height: 37px;
	    	display: flex;
	    }
	    
	    .search-option {
	    	color: gray;
	    	width: 100px;
	    	height: 100%;
	    	outline: none;
	    	border: 1px solid #ccc;
	    	margin-right: 5px;
	    	border-radius: 5px;
	    }
	    
	    .search-input {
	    	color: gray;
	    	background-color: white;
	    	border: 1px solid #ccc;
	    	font-size: 15px;
	    	padding: 5px 7px;
	    	border-radius: 5px;
	    }
	    
	    .search-input::placeholder {
	    	color: gray;
	    }
	    
	    .search-button {
	    	width: 60px;
	    	height: 100%;
	    	border-radius: 5px;
	    	display: flex;
	    	align-items: center;
	    	justify-content: center;
	    	font-size: 15px;
	    	color: #9780ff;
	    	border: 1px solid #9780ff;
	    	background-color: transparent;
	    	margin-left: 5px;
	    }
	    
	    .search-button:hover {
	    	background-color: #9780ff;
	    	color: white;
	    }
	    
	    .btn-write {
	    	background-color: rgb(223, 213, 242);
	    	color: black;
	    	padding: 6px 12px;
	    	font-size: 16px;
	    	cursor: pointer;
	    	border-radius: 5px;
	    	margin-left: 20px;
	    }
	    	    
	    </style>
    
</head>
<body>
    <!-- 헤더 인클루드 -->
    <%-- <%@ include file="header.jsp" %> --%>
    
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
    
    <script type="text/javascript">
    	//${msg}는 딜리트 에러 또는 딜리트 오케이 둘 중 하나
    	let msg = "${msg}"
    	if(msg == "DELETE_OK")
    		alert("삭제되었습니다.")
    	if(msg == "DELETE_ERROR")
    		alert("삭제되었거나 없는 게시물입니다.")	
    	//글쓰기 ㅇㅋ / ㄴㄴ 메세지
    	if(msg == "WRITE_OK")
    		alert("등록되었습니다.")
    	//수정 완료 메세지
    	if(msg == "MODE_OK")
    		alert("수정되었습니다.")
    </script>
    
    <div style="text-align: center;">
     	<div class="board-container">
     		<div class="search-container">
     		<!-- 게시물 찾기 버튼 추가 -->
     			<!-- ServiceDao Mapper까지 갔다가 보드리스트로 돌아오는 거임 -->
     			<form action="<c:url value='/board/list' />" class="search-form" method="get">
     				<!-- 찜목록 정렬에 쓸 수 있을 듯 -->
     				<!-- '$'{'}'안에 값 option은 PageResolver.java에 이미 다 정의해 놨음 -->
     				<select class="search-option" name="option">
     					<option value="A" ${pr.sc.option == 'A' || pr.sc.option == '' ? "selected" : "" }>제목+내용</option>
     					<option value="T" ${pr.sc.option == 'T' ? "selected" : "" }>제목</option>
     					<option value="W" ${pr.sc.option == 'W' ? "selected" : "" }>작성자</option>
     				</select>
     				<!-- EL안 키워드는 SearchItem의 keyword와 같음. 키워드는 내가 입력한 값이 되어 param(파라미터)으로 넘어감 -->
     				<input type="text" name="keyword" class="search-input" value="${param.keyword }" placeholder="검색어를 입력하세요" />
     				<input type="submit" value="검색" class="search-button" />
     			</form>
     			
     		<!-- 글쓰기 버튼 추가 / 버튼 자체에 url이 있으니 form 안에 안 넣어줌 -->
     			<button id="writeBtn" class="btn-write" onclick="location.href='<c:url value="/board/write" />'">
     				<i class="fas fa-pencil"></i>글쓰기
     			</button>
     		
     		</div>
     		
     		<table>
       			<tr>
     				<th class="no">번호</th>
     				<th class="title">제목</th>
     				<th class="writer">작성자</th>
     				<th class="regdate">등록일</th>
     				<th class="viewcnt">조회수</th>
     			</tr>
     			
     			<c:forEach var="boardDTO" items="${list }">
     				<tr>
     					<td class="no">${boardDTO.bno }</td>
     					<td class="title">									<!-- bno의 실제 값은 boardDTO에 있음 -->
     						<a href="<c:url value="/board/read${pr.sc.queryString}&bno=${boardDTO.bno }" />">${boardDTO.title }</a>
     					</td>
     					<td class="writer">
     						<a href="#">${boardDTO.writer }</a>
     					</td>
     					<td class="regdate">
     						<fmt:formatDate value="${boardDTO.reg_date }" pattern="yyyy-MM-dd" type="date" />
     					</td>
     					<td class="viewcnt">${boardDTO.view_cnt }</td>
     				</tr>
     			</c:forEach>
     		</table>
     		<br />
     		
     		<div class="paging-container">
     			<div class="paging">
     				<c:if test="${totalCnt == null || totalCnt == 0 }">
     					<div>게시물이 없습니다.</div>
     				</c:if>
     				<c:if test="${totalCnt != null || totalCnt != 0 }">
     					<c:if test="${pr.showPrev }">
     						<a class="page" href="<c:url value="/board/list${pr.sc.getQueryString(pr.beginPage-1) }" />">&lt;</a>
     					</c:if>
     					<c:forEach var="i" begin="${pr.beginPage }" end="${pr.endPage }">
     						<a class="page" href="<c:url value="/board/list${pr.sc.getQueryString(i) }" />">${i }</a>
     					</c:forEach>
     					
     					<c:if test="${pr.showNext }">
     						<a class="page" href="<c:url value="/board/list${pr.sc.getQueryString(pr.endPage+1) }" />">&gt;</a>
     					</c:if>
     					
     				</c:if>
     			</div>
     		</div>
     	</div>
    </div>
</body>
</html>
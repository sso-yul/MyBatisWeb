<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!--loginId에 sessionScope.id가 저장되어 있음  -->
<c:set var="loginId" value="${sessionScope.id }" />
<c:set var="loginout" value="${sessionScope.id == null ? 'Login' : 'Logout' }" />
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
    	
    	.board-container {
    		width: 60%;
    		height: 1200px;
    		margin: 0 auto;
    	}
    	
	    table {
	    	border-collapse: collapse;
	    	width: 100%;
	    	border-top: 2px solid #9780ff;
	    }
	    
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
    
    <div style="text-align: center;">
     	<div class="board-container">
     		<div class="search-container">
     		
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
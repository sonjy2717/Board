<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="homework.HWDTO"%>
<%@page import="java.util.List"%>
<%@page import="homework.HWDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//객체 생성 및 DB연결
HWDAO dao = new HWDAO(application);

//파라미터 저장용 Map컬렉션
Map<String, Object> param = new HashMap<String, Object>();

//board테이블에 저장된 게시물의 개수 카운트
int totalCount = dao.selectCount(param);

//검색 파라미터 얻어오기
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
//검색어가 있는 경우
if (searchWord != null) {
	//값을 추가 
  param.put("searchField", searchField);//검색필드명(title, content등)
  param.put("searchWord", searchWord);//검색어
}

//출력할 레코드 추출
List<HWDTO> boardLists = dao.selectList(param);

//자원 해제
dao.close();
%>
<%@ include file="./commons/header.jsp" %>
<body>
<div class="container">
    <!-- Top영역 -->
    <%@ include file="./commons/top.jsp" %>
    <!-- Body영역 -->
    <div class="row">
        <!-- Left메뉴영역 -->
        <%@ include file="./commons/left.jsp" %>
        <!-- Contents영역 -->
        <div class="col-9 pt-3">
            <h3>게시판 목록 - <small>자유게시판</small></h3>
            <!-- 검색 -->
            <div class="row">
                <form method="get">
                    <div class="input-group ms-auto" style="width: 400px;">
                        <select name="searchField" class="form-control">
                            <option value="title">제목</option>
                            <option value="content">내용</option>
                        </select>
                        <input type="text" name="searchWord" class="form-control" placeholder="Search" style="width: 200px;">
                        <button class="btn btn-success" type="submit">
                            <i class="bi-search" style="font-size: 1rem; color: white;"></i>
                        </button>
                    </div>
                </form>
            </div>
		    <!-- 게시판 리스트 -->
		    <div class="row mt-3 mx-1">
		        <table class="table table-bordered">
		            <tr class="text-center">
		                <th width="9%">번호</th>
		                <th width="44%">제목</th>
		                <th width="19%">작성자</th>
		                <th width="7%">조회수</th>
		                <th width="22%">작성일</th>
		            </tr>
		        </table>
		    </div>
			<table class="table table-bordered" width="100%">
<%
if (boardLists.isEmpty()) {
    // 게시물이 하나도 없을 때 
%>
	        <tr>
	            <td colspan="5" align="center">
	                등록된 게시물이 없습니다^^*
	            </td>
	        </tr>
<%
}
else {
    // 게시물이 있을 때 
   	int virtualNum = 0;//게시물의 출력 번호 
   	int countNum = 0;
    
    //확장 for문을 통해 List컬렉션에 저장된 레코드의 갯수만큼 반복한다.
    for (HWDTO dto : boardLists)
    {
    	//전체 레코드 수를 1씩 차감하면서 번호를 출력
        virtualNum = totalCount--;
%>
	        <tr align="center">
	            <td><%= virtualNum %></td>  
	            <td align="left"> 
	                <a href="viewT.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a> 
	            </td>
	            <td align="center"><%= dto.getId() %></td>           
	            <td align="center"><%= dto.getVisitcount() %></td>   
	            <td align="center"><%= dto.getPostdate() %></td>    
	        </tr>
<%
    }
}
%>
    		</table>
            <!-- 각종버튼 -->
            <div class="row">
                <div class="col d-flex justify-content-end">
                    <button type="button" class="btn btn-primary" onclick="location.href='writeT.jsp';">글쓰기</button>
                    <button type="button" class="btn btn-secondary">수정하기</button>
                    <button type="button" class="btn btn-success">삭제하기</button>
                    <button type="button" class="btn btn-info">답글쓰기</button>
                    <button type="button" class="btn btn-warning">목록보기</button>
                    <button type="button" class="btn btn-danger">전송하기</button>
                    <button type="button" class="btn btn-dark">다시쓰기</button>
                </div>
            </div>
            <!-- 페이지 번호 -->
            <div class="row mt-3">
                <div class="col">
                    <ul class="pagination justify-content-center">
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-backward-fill'></i>
                        </a></li>
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-start-fill'></i>
                        </a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-end-fill'></i>
                        </a></li>
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-forward-fill'></i>
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!-- Copyright영역 -->
    <%@ include file="./commons/copyright.jsp" %>
</div>
</body>
</html>
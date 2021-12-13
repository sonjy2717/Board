<%@page import="homework.HWDTO"%>
<%@page import="homework.HWDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 글쓰기 페이지 진입전 로그인 확인 -->
<%@ include file="./LoginCheck.jsp" %>
<%
String num = request.getParameter("num"); //게시물의 일련번호
HWDAO dao = new HWDAO(application); //DB연결
HWDTO dto = dao.selectView(num); //게시물 조회
//세션 영역에 저장된 회원 아이디를 얻어와서 문자열의 형태로 변환
String sessionId = session.getAttribute("UserId").toString();
/*
본인이 작성한 글이 아니어도 URL패턴을 분석하면 수정 페이지로 집입할 수
있으므로 페이지 진입 전 본인확인을 추가로 하는 것이 안전하다.
*/
if (!sessionId.equals(dto.getId())) {
	JSFunction.alertBack("작성자 본인만 수정할 수 있습니다.", out);
	return;
}
dao.close();
%>
<script type="text/javascript">
function validateForm(form) {
	if (form.name.value == "") {
		alert("작성자를 입력하세요.");
		form.name.focus();
		return false;
	}
	if (form.title.value == "") {
		alert("제목을 입력하세요.");
		form.title.focus();
		return false;
	}
	if (form.content.value == "") {
		alert("내용을 입력하세요.");
		form.content.focus();
		return false;
	}
}

function deletePost() {
	var confirmed = confirm("정말로 삭제하겠습니까?");
	if (confirmed) {
		var form = document.writeFrm;
		form.method = "post"; //전송방식을 post로 설정
		form.action = "DeleteProcess.jsp"; //전송할 URL
		form.submit(); //폼값 전송
	}
}

function editPost() {
	var form = document.writeFrm;
	form.method = "post";
	form.action = "EditProcess.jsp";
	form.submit();
}
</script>
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
            <h3>게시판 내용보기 - <small>자유게시판</small></h3>
            
            <form name="writeFrm" onsubmit="return validateForm(this);">           
			<input type="hidden" name="num" value="<%= dto.getNum() %>" />
				
                <table class="table table-bordered">
                <colgroup>
                    <col width="20%"/>
                    <col width="30%"/>
                    <col width="20%"/>
                    <col width="*"/>
                </colgroup>
                <tbody>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">작성자</th>
                        <td>
                        	<%= dto.getName() %>
                        </td>
                        <th class="text-center" 
                            style="vertical-align:middle;">작성일</th>
                        <td>
                            <%= dto.getPostdate() %>
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">이메일</th>
                        <td>
                        	sonjy2717@naver.com
                        </td>
                        <th class="text-center" 
                            style="vertical-align:middle;">조회수</th>
                        <td>
                            <%= dto.getVisitcount() %>
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">제목</th>
                        <td colspan="3">
                        	<input type="text" name="title" value="<%= dto.getTitle() %>" />
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">내용</th>
                        <td colspan="3">
                        	<textarea name="content" style="width: 90%; height: 100px"><%= dto.getContent() %></textarea> 
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">첨부파일</th>
                        <td colspan="3">
                            
                        </td>
                    </tr>
                </tbody>
                </table>
            </form>
				
            <!-- 각종버튼 -->
            <div class="row mb-3">
                <div class="col d-flex justify-content-end">
                    <button type="button" class="btn btn-primary" onclick="location.href='writeT.jsp';">글쓰기</button>
	                <%
	                if (session.getAttribute("UserId") != null
	            	&& session.getAttribute("UserId").toString().equals(dto.getId())) {
	            	%>
                    <button type="button" class="btn btn-success" onclick="deletePost();">삭제하기</button>
                    <button type="button" class="btn btn-secondary" onclick="editPost();">수정완료</button>
	                <%
	                }
	                %>
                    <button type="button" class="btn btn-info">답글쓰기</button>
                    <button type="button" class="btn btn-warning" onclick="location.href='listT.jsp';">목록보기</button>
                    <button type="button" class="btn btn-danger">전송하기</button>
                    <button type="button" class="btn btn-dark">다시쓰기</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Copyright영역 -->
    <%@ include file="./commons/copyright.jsp" %>
</div>
</body>
</html>
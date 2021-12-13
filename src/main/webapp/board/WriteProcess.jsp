<%@page import="homework.JSFunction"%>
<%@page import="homework.HWDAO"%>
<%@page import="homework.HWDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 글쓰기 처리(insert)전 로그인 확인 -->
<%@ include file="./LoginCheck.jsp" %>
<%
//폼값 받기
String title = request.getParameter("title");
String content = request.getParameter("content");

//사용자가 입력한 폼값을 저장하기 위해 DTO객체 생성
HWDTO dto = new HWDTO();
dto.setTitle(title);
dto.setContent(content);
//세션영역에 저장된 회원 인증정보(아이디)를 가져와서 DTO에 저장한다
dto.setId(session.getAttribute("UserId").toString());

//DAO객체 생성 및 DB연결
HWDAO dao = new HWDAO(application);
//dto객체를 매개변수로 전달하여 레코드 insert 처리
int iResult = dao.insertWrite(dto);
//자원 해제
dao.close();

if (iResult == 1) {
	//글쓰기에 성공했다면 리스트(목록) 페이지로 이동한다.
	response.sendRedirect("listT.jsp");
}
else {
	//실패한 경우에는 글쓰기 페이지로 이동한다. 즉 뒤로 이동한다.
	JSFunction.alertBack("글쓰기에 실패하였습니다.", out);
}
%>
<%@page import="homework.HWDAO"%>
<%@page import="homework.HWDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./LoginCheck.jsp" %>
<%
//수정 페이지에서 전송한 폼값 받기
String num = request.getParameter("num");
String name = request.getParameter("name");
String title = request.getParameter("title");
String content = request.getParameter("content");

//DTO객체에 입력값 추가하기
HWDTO dto = new HWDTO();
dto.setNum(num);
dto.setName(name);
dto.setTitle(title);
dto.setContent(content);

//DB연결
HWDAO dao = new HWDAO(application);
//수정 처리
int affected = dao.updateEdit(dto);
//자원 해제
dao.close();

if (affected == 1) {
	//수정에 성공한 경우에는 수정된 내용을 확인하기 위해 상세보기 페이지로 이동
	response.sendRedirect("viewT.jsp?num=" + dto.getNum());
}
else {
	//실패한 경우에는 뒤로 이동
	JSFunction.alertBack("수정하기에 실패하였습니다.", out);
}
%>
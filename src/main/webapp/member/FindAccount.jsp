<%@page import="homework.BoardPage"%>
<%@page import="homework.HWDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
HWDAO dao = new HWDAO(application);

String id = request.getParameter("id");
String name = request.getParameter("name");
String find = request.getParameter("find");

String accountId = dao.findId(name);
String accountPw = dao.findPw(id, name);

if (find.equals("id") && !accountId.equals("")) {
	out.println("당신의 아이디는 \'" + accountId + "\'입니다.");
}
else if (find.equals("pw") && !accountPw.equals("")) {
	out.println("당신의 비밀번호는 \'" + accountPw + "\'입니다.");
	BoardPage.pageLogin();
}
else {
	out.println("일치하는 정보가 없습니다.");
}

dao.close();
%>
<%= BoardPage.pageLogin() %>
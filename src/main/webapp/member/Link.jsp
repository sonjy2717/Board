<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<table border="1" width="90%"> 
    <tr>
        <td align="center">
        <!-- 로그인 여부에 따른 메뉴 변화 -->
        <% 
        if (session.getAttribute("UserId") == null) { 
        %>
            <a href="./LoginForm.jsp">로그인</a>
        <%
        } 
        else { 
        %>
            <a href="./Logout.jsp">로그아웃</a>
        <% 
        } 
        %>
        </td>
    </tr>
</table>

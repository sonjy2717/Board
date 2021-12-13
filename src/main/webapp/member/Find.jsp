<%@page import="homework.HWDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>계정 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <style>
        *{padding: 0;font-size: 12px;}
        h2{font-size: 25px;font-family: 굴림;}
        #AllWrap{margin:0 auto; text-align:center;}
        #RadioBox{margin:0 auto;text-align:left;width: 600px;margin-bottom: 10px;}
        #IdBox{margin:0 auto;border:10px solid rgb(218, 218, 218);padding: 10px;width: 700px;}
        #InputTable{border:0px solid red; border-spacing: 0; border-collapse: collapse;width: 500px;}        
        #InputTable th{text-align:left; padding: 10px;}
        #InputTable td{text-align:left; padding: 10px;}
        #InputTable input{border:1px solid gray;height: 26px;padding:0 0 0 3px;}
        #InputTable select{border:1px solid gray;height: 25px;padding: 4px;width:90px;}
        #btn1, #btn2{
            background-color: rgb(212, 0, 0);color: white;padding: 5px 20px;border:0;
            font-size: 13px;font-weight: bold;border-radius: 5px;
        }
        #btn2{display: none;}
        .bullet{color: red;font-weight: bold;margin-right: 5px;font-size: 16px;}
    </style>
    <script>
    $(function(){
        $('#idFind').click(function(){
            $('#item01').hide();
            $('#item02').show();
            $('#item03').show();
            $('#btn1').show();
            $('#btn2').hide();
            $('#inner').text('아이디를 찾기 위해서 이름을 입력하세요.');
            //$('#item04').show();
            //$('#item05').hide();
        });
        $('#pwFind').click(function(){
            $('#item01').show();
            $('#item02').show();
            $('#item03').show();
            $('#btn1').hide();
            $('#btn2').show();
            $('#inner').text('비밀번호를 찾기 위해서 아이디와 이름을 입력하세요.');
            //$('#item04').show();
            //$('#item05').hide();
        });
        $('#choice').change(function(){
            if($('#choice').val()=='mobile'){
                $('#item04').show();
                $('#item05').hide();
            }
            else{
                $('#item04').hide();
                $('#item05').show();
            }
        });
    });
    
    function check(form) {
    	if (form.find.value == "id") {
    		if (form.name.value == "") {
    			alert("빈 칸 없이 입력해 주세요.");
    			form.name.focus();
    			return false;
    		}
    	}
    	else if (form.find.value == "pw") {
    		if (form.id.value == "" || form.name.value == "") {
    			alert("빈 칸 없이 입력해 주세요.");
    			if (!form.id.value == "") {
    				form.name.focus();
    			}
    			else {
    				form.id.focus();
    			}
    			return false;
    		}
    	}
    }
    </script>
</head>
<body>
<form action="FindAccount.jsp" method="post" onsubmit="return check(this);">
<div id="AllWrap">
    <h2>아이디/비밀번호 찾기</h2>
    <div id="RadioBox">
        <input type="radio" name="find" value="id" id="idFind" checked>아이디 찾기
        &nbsp;&nbsp;&nbsp;&nbsp;
        <input type="radio" name="find" value="pw" id="pwFind">비밀번호 찾기
    </div>
    <div id="IdBox" class="">
        <table align="center" id="InputTable">
            <colgroup>
                <col width="30%" />
                <col width="70%" />
            </colgroup>
            <tr id="item01" style="display:none;">
                <th><span class="bullet">&gt;</span><strong>아 이 디</strong></th>
                <td>
                    <input type="text" name="id" style="width:200px;">
                </td>
            </tr>
            <tr id="item02">
                <th><span class="bullet">&gt;</span><strong>이 름</strong></th>
                <td>
                    <input type="text" name="name" style="width:200px;">
                </td>
            </tr>
            <!-- <tr id="item03">
                <th>
                    <span class="bullet">&gt;</span><select id="choice">
                        <option value="mobile" selected>휴대전화</option>
                        <option value="email">이메일</option>
                    </select>
                </th>
                <td>
                    <div id="item04">
                        <input type="text" name="mobile1" style="width:40px;" maxlength="3"> -
                        <input type="text" name="mobile2" style="width:50px;" maxlength="4"> -
                        <input type="text" name="mobile3" style="width:50px;" maxlength="4">
                    </div>
                    <div id="item05" style="display:none;">
                        <input type="text" name="email1" style="width:100px;"> @
                        <input type="text" name="email2" style="width:100px;">
                        <select name="" id="">
                            <option value="">-- 선택 --</option>
                            <option value="naver.com">naver.com</option>
                            <option value="nate.com">nate.com</option>
                            <option value="gmail.com">gmail.com</option>
                            <option value="daum.net">daum.net</option>
                            <option value="hanmail.net">hanmail.net</option>
                            <option value="직접입력" selected>직접입력</option>
                        </select>
                    </div>
                </td>
            </tr> -->
        </table>
        <div>
            <img src="./images/g_line.gif" width="400" height="1" border="0" />
            <br><br><br>
            <div id="inner">
            아이디를 찾기 위해서 이름을 입력하세요.
            </div>
            <br><br><br>
        </div>
    </div>
    <div style="margin-top:20px;">
        <input type="submit" value="아이디 찾기 &gt;" id="btn1">
        <input type="submit" value="비밀번호 찾기 &gt;" id="btn2">
    </div>
</div>
</form>
</body>
</html>
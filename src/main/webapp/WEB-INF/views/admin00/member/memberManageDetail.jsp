<%@ page language="java" contentType="text/html; charset=utf-8"
pageEncoding="utf-8" isELIgnored="false" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

    <script>
      function backToList() {
        location.href =
          "${contextPath}/admin/member/memberManageList.do?page=adminPage";
      }

      function fn_remove_member(member_id) {
        var formObj = document.createElement("form");
        var m_member = document.createElement("input");
        m_member.name = "member_id";
        m_member.value = member_id;
        formObj.appendChild(m_member);
        document.body.appendChild(formObj);
        formObj.method = "post";
        formObj.action = "${contextPath}/admin/member/removeMember.do";
        formObj.submit();
      }
    </script>

    <style>
      .member_cont {
        padding: 20px 100px;
        border: 1px solid #dbdbdb;
        width: 690px;
        margin: 0 auto;
      }
      .mod_input_sec > div {
        float: left;
      }
      .join_input_sec input {
        display: block;
        width: 350px;
        height: 36px;
        margin: 0 0 3px 16px;
        padding: 0 0 0 18px;
        border: 1px solid #d0d0d0;
        color: #979d9d;
      }

      .listBtn {
        width: 100px;
        height: 50px;
        background-color: #007bff;
        font-size: 16px;
        font-weight: bold;
        border: none;
        border-radius: 8px;
      }
    </style>
  </head>
  <body>
    <div class="content_box">
      <div class="member_wrap">
        <div class="member_tit">
          <h2>회원 정보 조회</h2>
          <input
            type="button"
            value="삭제"
            style="
              width: 100px;
              display: inline-block;
              margin-left: 590px;
              margin-bottom: 20px;
            "
            onclick="fn_remove_member('${member.member_id}')"
          />
        </div>

        <div class="member_cont">
          <form id="membermodfrom" method="post" novalidate="novalidate">
            <div class="member_mod_box">
              <img src="/image/Babee_Logo.png" /><br /><br />
              <div class="join_input_sec">
                <table>
                  <tr>
                    <td width="150"><h4 align="center">기본정보</h4></td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="150"><p align="right">아이디 *</p></td>
                    <td width="300">
                      <input
                        type="text"
                        name="member_id"
                        value="${member.member_id}"
                        disabled
                      />
                      <input
                        type="hidden"
                        name="member_id"
                        value="${member.member_id}"
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">비밀번호 *</p></td>
                    <td>
                      <input
                        type="password"
                        name="member_pw"
                        value="${member.member_pw}"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">이름 *</p></td>
                    <td>
                      <input
                        type="text"
                        name="member_name"
                        value="${member.member_name}"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">이메일</p></td>
                    <td>
                      <input
                        type="email"
                        name="member_email"
                        value="${member.member_email}"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">일반전화</p></td>
                    <td>
                      <input
                        type="text"
                        name="member_tel1"
                        value="${member.member_tel1}"
                        style="width: 75px; display: inline-block"
                        disabled
                      />
                      <input
                        type="text"
                        name="member_tel2"
                        value="${member.member_tel2}"
                        style="width: 80px; display: inline-block"
                        disabled
                      />
                      <input
                        type="text"
                        name="member_tel3"
                        value="${member.member_tel3}"
                        style="width: 80px; display: inline-block"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">휴대전화 *</p></td>
                    <td>
                      <input
                        type="text"
                        name="member_hp1"
                        value="${member.member_hp1}"
                        style="width: 75px; display: inline-block"
                        disabled
                      />
                      <input
                        type="text"
                        name="member_hp2"
                        value="${member.member_hp2}"
                        style="width: 80px; display: inline-block"
                        disabled
                      />
                      <input
                        type="text"
                        name="member_hp3"
                        value="${member.member_hp3}"
                        style="width: 80px; display: inline-block"
                        disabled
                      />
                    </td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="150"><p align="right">주소</p></td>
                    <td>
                      <input
                        type="text"
                        placeholder="우편 번호"
                        name="member_zipcode"
                        style="margin-bottom: 5px"
                        value="${member.member_zipcode}"
                        name="member_zipcode"
                        id="member_zipcode"
                        disabled
                      />
                      <input
                        type="text"
                        placeholder="도로명 주소"
                        name="member_roadAddr"
                        value="${member.member_roadAddr}"
                        id="member_roadAddr"
                        style="margin-bottom: 5px"
                        disabled
                      /><br />
                      <input
                        type="text"
                        placeholder="지번 주소"
                        name="member_jibunAddr"
                        value="${member.member_jibunAddr}"
                        id="member_jibunAddr"
                        style="margin-bottom: 5px"
                        disabled
                      /><br />
                      <input
                        type="text"
                        placeholder="나머지 주소"
                        name="member_namujiAddr"
                        value="${member.member_namujiAddr}"
                        id="member_namujiAddr"
                        style="margin-bottom: 15px"
                        disabled
                      />
                    </td>
                  </tr>
                </table>
                <br />
                <table>
                  <tr>
                    <td width="150"><h4 align="right">추가정보</h4></td>
                    <td>&nbsp;</td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">성별</p></td>
                    <td>
                      <input
                        type="text"
                        name="member_gender"
                        value="${member.member_gender}"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">생년월일</p></td>
                    <td>
                      <input
                        type="date"
                        name="member_birth"
                        value="${member.member_birth}"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150"><p align="right">자녀 성별</p></td>
                    <td>
                      <input
                        type="text"
                        name="baby_gender"
                        value="${member.baby_gender}"
                        disabled
                      />
                    </td>
                  </tr>

                  <tr>
                    <td width="150">
                      <p align="right">
                        자녀 나이
                        <span style="font-size: 8px; display: inline"
                          >(개월수)</span
                        >
                      </p>
                    </td>
                    <td>
                      <input
                        type="text"
                        name="baby_age"
                        value="${member.baby_age}"
                        disabled
                      />
                    </td>
                  </tr>
                </table>
                <input
                  type="button"
                  class="listBtn"
                  style="color: white; margin: 30px auto; padding: 0"
                  onClick="backToList()"
                  value="목록 보기"
                />
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
    <br /><br /><br /><br /><br /><br /><br />
  </body>
</html>

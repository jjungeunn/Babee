<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"  isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="myGoodsList"  value="${cartMap.myGoodsList}"  />
<c:set var="goodsList"  value="${goodsList}"  />

<head>
<style>

/* '삭제' 버튼 스타일 */
#deleteButton1 > a {
   background-color: #ffcd29; /* 배경색 */
   color: black; /* 텍스트색 */
   padding: 8px 8px; /* 내부 여백 */
   border: none; /* 테두리 없음 */
   border-radius: 5px; /* 테두리 반경 */
   cursor: pointer; /* 커서 모양 변경 */
   text-decoration: none;
}

/* 버튼에 호버 효과 */
#deleteButton1>a:hover {
   background-color: #cca300; /* 호버 시 배경색 변경 */
}

ul li {
   list-style-type: none;
}

.cart_list {
   border-collapse: collapse;
   border-bottom: 1px solid #ccc;
}

.cart_list td {
   border-top: 1px solid #ccc;
}

.cart_img {
   width: 100px;
   height: 100px;
   border-radius: 10px; /* 둥근 경계선 추가 */
   margin-top: 10px; /* 위쪽 마진 추가 */
   margin-bottom: 10px; /* 아래쪽 마진 추가 */
   transition: transform 0.2s;
}
.cart_img:hover {
    transform: scale(1.1);
}

/* 체크박스 스타일 */
input[type="checkbox"] {
  width: 20px; /* 체크박스 너비 조절 */
  height: 20px; /* 체크박스 높이 조절 */
  margin-top: -2px;
  border: 2px solid #ccc; /* 테두리 스타일 지정 */
  border-radius: 5px; /* 둥근 테두리 적용 */
  outline: none; /* 포커스 스타일 제거 */
  vertical-align: middle;
}


/* 전체 선택 텍스트 스타일 */
#select-all-checkbox-label {
  vertical-align: middle; /* 세로 중앙 정렬 */
  margin-left: 20px; /* 좌측 마진을 추가하여 체크박스와 텍스트 사이 간격 조절 */
}

/* 버튼 스타일 */
input[type="button"] {
  background-color: #ffcd29; /* 배경색 */
  color: black; /* 텍스트색 */
  padding: 10px 20px; /* 내부 여백 */
  border: none; /* 테두리 없음 */
  border-radius: 5px; /* 테두리 반경 */
  cursor: pointer; /* 커서 모양 변경 */
  font-size: 16px; /* 폰트 크기 */
}

/* 버튼에 호버 효과 */
input[type="button"]:hover {
  background-color: #cca300; /* 호버 시 배경색 변경 */
  color: #fff;
}

	.cart_list_a { 
		width: 66%;
    	margin: 0 auto;
    	}
    	
	.cart_list tr td {
		padding: 10px;
	}
	
	      a:hover {
        font-weight: bold;
      }

      a {
        color: black;
        text-decoration: none;
      }
   
</style>



<title>장바구니 창</title>

<script type="text/javascript">


function selectAll() {
    var checkboxes = document.querySelectorAll('.product-checkbox');
    var selectAllCheckbox = document.getElementById('select-all-checkbox');

    for (var i = 0; i < checkboxes.length; i++) {
       if (!checkboxes[i].disabled) {
          checkboxes[i].checked = selectAllCheckbox.checked;
       }
    }

    updateTotalPrices();
 }
   $(document).ready(function() {
                  // 클래스가 "product-checkbox"인 체크박스 변경 감지
                  $(".product-checkbox")
                        .change(
                              function() {

                                 var totalGoodsNum = 0;
                                 var totalGoodsPrice = 0;
                                 var totalDiscountedPrice = 0;                                 

                                 $(".product-checkbox:checked").each(
                                             function() {
                                                var parent = $(this).closest("tr");
                                                var priceElement = parseInt(parent.find(".price").text());
                                                var quantityElement = parseInt(parent.find(".order_goods_qty").val()); 
                                            
                                                

                                                
                                                totalGoodsNum++;
                                                totalGoodsPrice += (priceElement * quantityElement); 
                                                totalDiscountedPrice += ((priceElement /10) * quantityElement); 
                                             });

                                 var finalTotalPrice = totalGoodsPrice - totalDiscountedPrice + 3000;

                                 // 선택된 상품 정보 업데이트
                                 $("#p_totalGoodsNum").text(totalGoodsNum.toLocaleString() + "개");
                                 $("#p_totalGoodsPrice").text(totalGoodsPrice.toLocaleString() + "원");
                                 $("#p_totalDiscountedPrice").text(totalDiscountedPrice.toLocaleString() + "원");
                                 $("#p_final_totalPrice").text(finalTotalPrice.toLocaleString() + "원");

                              });
               });

   

function delete_cart_goods(cart_id) {
      var cart_id = Number(cart_id);
      var formObj = document.createElement("form");
      var i_cart = document.createElement("input");
      i_cart.name = "cart_id";
      i_cart.value = cart_id;

      formObj.appendChild(i_cart);
      document.body.appendChild(formObj);
      formObj.method = "post";
      formObj.action = "${contextPath}/cart/removeCartGoods.do";
      formObj.submit();
   }

   

 function fnOrderGoods() {
       var cartOrderArr = [];

       var selectedCheckboxes = $(".product-checkbox:checked");
       if (selectedCheckboxes.length === 0) {
           alert("선택된 상품이 없습니다.");
           return;
       }

       selectedCheckboxes.each(function () {
           var row = $(this).closest("tr");
           var goodsId = row.find(".goodsId").val();
           var quantity = row.find(".order_goods_qty").val();
           var option = row.find("#_goods_option").val();

           cartOrderArr.push({
               goodsId: goodsId,
               quantity: quantity,
               option: option
           });
       });

       console.log("cartOrderArr", cartOrderArr);

       var form = document.createElement("form");
       form.setAttribute("method", "post");
       form.setAttribute("action", "${contextPath}/order/cartOrder.do");

       // cartOrderArr을 반복하며 입력 생성 및 추가
       for (var i = 0; i < cartOrderArr.length; i++) {
           var orderData = cartOrderArr[i];

           var inputGoodsId = document.createElement("input");
           inputGoodsId.setAttribute("type", "hidden");
           inputGoodsId.setAttribute("name", "selected_goods_id");
           inputGoodsId.setAttribute("value", orderData.goodsId);
           form.appendChild(inputGoodsId);

           var inputQuantity = document.createElement("input");
           inputQuantity.setAttribute("type", "hidden");
           inputQuantity.setAttribute("name", "selected_quantity");
           inputQuantity.setAttribute("value", orderData.quantity);
           form.appendChild(inputQuantity);

           var inputOption = document.createElement("input");
           inputOption.setAttribute("type", "hidden");
           inputOption.setAttribute("name", "selected_option");
           inputOption.setAttribute("value", orderData.option);
           form.appendChild(inputOption);
       }

       document.body.appendChild(form);
       form.submit();
   }


 function updateTotalPrices() {
	   var totalGoodsNum = 0;
	   var totalGoodsPrice = 0;
	   var totalDiscountedPrice = 0;

	   $(".product-checkbox:checked").each(function () {
	      var parent = $(this).closest("tr");
	      var priceElement = parseInt(parent.find(".price").text());
	      var quantityElement = parseInt(parent.find(".order_goods_qty").val());

	      totalGoodsNum++;
	      totalGoodsPrice += priceElement * quantityElement;
	      totalDiscountedPrice += (priceElement / 10) * quantityElement;
	   });

	   var finalTotalPrice = totalGoodsPrice - totalDiscountedPrice + 3000;

	   // 선택된 상품 정보 업데이트
	   $("#p_totalGoodsNum").text(totalGoodsNum.toLocaleString() + "개");
	   $("#p_totalGoodsPrice").text(totalGoodsPrice.toLocaleString() + "원");
	   $("#p_totalDiscountedPrice").text(totalDiscountedPrice.toLocaleString() + "원");
	   $("#p_final_totalPrice").text(finalTotalPrice.toLocaleString() + "원");

	   // 여기에 ajax 호출 등의 추가 작업 가능
	   $(document).ready(function() {
           // 클래스가 "product-checkbox"인 체크박스 변경 감지
           $(".product-checkbox")
                 .change(
                       function() {

                          var totalGoodsNum = 0;
                          var totalGoodsPrice = 0;
                          var totalDiscountedPrice = 0;                      

                          $(".product-checkbox:checked").each(
                                      function() {
                                         var parent = $(this).closest("tr");
                                         var priceElement = parseInt(parent.find(".price").text());
                                         var quantityElement = parseInt(parent.find(".order_goods_qty").val()); 
                                         

                                         
                                         totalGoodsNum++;
                                         totalGoodsPrice += (priceElement * quantityElement); 
                                         totalDiscountedPrice += ((priceElement /10) * quantityElement); 
                                      });

                          var finalTotalPrice = totalGoodsPrice - totalDiscountedPrice + 3000;

                          // 선택된 상품 정보 업데이트
                          $("#p_totalGoodsNum").text(totalGoodsNum.toLocaleString() + "개");
                          $("#p_totalGoodsPrice").text(totalGoodsPrice.toLocaleString() + "원");
                          $("#p_totalDiscountedPrice").text(totalDiscountedPrice.toLocaleString() + "원");
                          $("#p_final_totalPrice").text(finalTotalPrice.toLocaleString() + "원");

                       });
        });
	}

</script>

</head>


<body>
<form action="${contextPath}/order/cartOrder.do" method="post" name="cartorderForm" enctype="multipart/form-data">
   <div class="cart_list_a"  style="margin-left:165px;">
		<H3 style="display:inline-grid;">나의 장바구니</H3>
		<hr style="margin-top:revert">
		<table align="center" style="margin-left: 0px;">
			<tr>
				<td> 
					<img src ="/image/people.png" width="60px;" style="display:inline-block; padding-left:15px;"/>
               				<c:if test="${userType=='S'}">
                  <p  style="display:inline-block;"> ${memberInfo.seller_name} 님 안녕하세요 </p>
               	</c:if>
               	<c:if test="${userType!='S'}">
                  <p  style="display:inline-block;"> ${memberInfo.member_name} 님 안녕하세요 </p>
               	</c:if>
            </td>
				</td>
         	</tr>
      	</table>
		<hr style=" margin-bottom: 50px;">

   
   
   
   <div style="width: 100%;">

      <div>
         <table class="cart_list" style="width: 100%;">
            <tr>
               <td width="120px;" height="15px;">
                  <div class="text_center">
                     <input type="checkbox" id="select-all-checkbox" onchange="selectAll()" > <span style="font-weight:bold;">전체 선택</span>
                  </div>
               </td>
               <td colspan="2" width="300px" style="font-weight:bold;">상품 정보</td>
               <td width="98px" style="font-weight:bold;">가격</td>
               <td width="98px" style="font-weight:bold;">수량</td>
               <td width="100px" style="font-weight:bold;">옵션</td>
               <td width="70px" style="font-weight:bold;"></td>
            </tr>

            <c:forEach var="cartVO" items="${myCartList}" varStatus="loop">
               <tr>
                  <td class="text_center"> <input type="checkbox" class="product-checkbox" ${cartVO.goodsVO.goods_stock == 0 ? 'disabled' : ''}></td>
                        <input type="hidden" class="goodsId" value="${cartVO.goods_id}">
                  <td style="text-align: left;"><a href="${contextPath}/goods/goodsDetail.do?goods_id=${cartVO.goods_id}"><img src="${contextPath}/thumbnails.do?goods_id=${cartVO.goods_id}&fileName=${cartVO.cart_image_name}" width="100px" height="100px"class="cart_img"/></a></td>
                  <td style="text-align: left;"><a href="${contextPath}/goods/goodsDetail.do?goods_id=${cartVO.goods_id}">${cartVO.goods_title}</td>
                  <td><span class="price">${cartVO.goods_price} 원</span></td>
                  <td><span class="quantity">
              
					
						
						<c:choose>
						<c:when test="${cartVO.goodsVO.goods_stock ==0}">
							<input type="hidden" class="goods-stock" value="${cartVO.goodsVO.goods_stock}">

							 품절
							 
						</c:when>
						
						<c:when test="${goodsVO.goods_stock !=0}">

 				        <input type="number" value="${cartVO.cart_goods_qty}" data-index="${loop.index}" class="order_goods_qty" name="order_goods_qty" style="width: 60px; height: 25px; text-align: center; border: 1px solid #ccc; border-radius: 5px;" onchange="updateTotalPrices()" min="1" max="${cartVO.goodsVO.goods_stock}">
 				        </c:when>
 				        </c:choose>
 				        </span> 
 				        
 				        </td>   
 				            
                  
                  <td>
					  <select style="width: 100px; height: 25px; text-align: center; border: 1px solid #ccc; border-radius: 5px;" id="_goods_option" name="goods_option">
					    <option value="${cartVO.goods_option1}">${cartVO.goods_option1}</option>
					    <option value="${cartVO.goods_option2}">${cartVO.goods_option2}</option>
					    <option value="${cartVO.goods_option3}">${cartVO.goods_option3}</option>
					    <option value="${cartVO.goods_option4}">${cartVO.goods_option4}</option>
					    <option value="${cartVO.goods_option5}">${cartVO.goods_option5}</option>
					  </select>
					</td>
                  
                  <td id="deleteButton1">  <a href="javascript:delete_cart_goods(${cartVO.cart_id})" style="font-size: 3px;" ><b><span>삭제</span></b></a> </td>
                  
               </tr>
            </c:forEach>

         </table>
      </div>
      <br> <br>

      <!-- 체크 한 상품의 정보 출력해주는 div -->
      <div class="text_center">
      
            <table width=100% class="text_center" style="background: #ffffcc">
               <tbody>
                  <tr align=center class="fixed">
                     <td class="fixed">총 상품수</td>
                     <td>총 상품금액</td>
                     <td>할인금액</td>
                     <td>배송비</td>
                     <td>최종 결제금액</td>
                  </tr>
                  
                  <tr cellpadding=40 align=center>
                     <td>
                        <p id="p_totalGoodsNum">0개</p>
                        <input id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}" />
                     </td>
                     <td>
                        <p id="p_totalGoodsPrice">
                           <fmt:formatNumber value="${totalGoodsPrice}" type="number" var="total_goods_price" />${total_goods_price}원
                        </p>
                        <input id="h_totalGoodsPrice" type="hidden" value="${totalGoodsPrice}" />
                     </td>
                     <td>
                        <p id="p_totalDiscountedPrice">
                           <fmt:formatNumber value="${totalDiscountedPrice}" type="number" var="totalDiscountedPrice" />${totalDiscountedPrice}원
                        </p>
                     </td>
                     <td>
                        <p>3,000 원</p>
                     </td>
                     <td>
                        <p id="p_final_totalPrice">
                           <fmt:formatNumber value="${totalGoodsPrice-totalDiscountedPrice}" type="number" var="total_price" /> ${total_price}원
                        </p>
                        <input id="h_final_totalPrice" type="hidden" value="${totalGoodsPrice-totalDiscountedPrice}" />
                     </td>
                  </tr>
               </tbody>
            </table>
         
      </div>
   </div>
	</div>

   <br><br>   <input type="button" onClick="javascript:fnOrderGoods()" value="구매하기">
   
 </form>
</body>
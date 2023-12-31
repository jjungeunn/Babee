package com.babee.order.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.babee.common.base.BaseController;
import com.babee.diary.service.DiaryService;
import com.babee.goods.dao.GoodsDAO;
import com.babee.goods.service.GoodsService;
import com.babee.goods.vo.GoodsVO;
import com.babee.member.vo.MemberVO;
import com.babee.order.service.OrderService;
import com.babee.order.vo.OrderVO;
import com.babee.seller.vo.SellerVO;



@Controller("orderController")
@RequestMapping(value="/order")
public class OrderControllerImpl extends BaseController implements OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private OrderVO orderVO;
	@Autowired
	private GoodsVO goodsVO;
	@Autowired
	private DiaryService diaryService;
	@Autowired
	private GoodsDAO goodsDAO;
	
	@RequestMapping(value="/orderEachGoods.do" , method=RequestMethod.POST)
	public ModelAndView orderEachGoods(@ModelAttribute("orderVO") OrderVO orderVO,
			                       HttpServletRequest request, HttpServletResponse response)  throws Exception{		
		request.setCharacterEncoding("utf-8");
		HttpSession session=request.getSession();
		session=request.getSession();
		ModelAndView mav = new ModelAndView("/goods/orderGoodsForm");
		Map goodsVO1=goodsService.goodsDetail(orderVO.getGoods_id());
		GoodsVO goodsVO =(GoodsVO)goodsVO1.get("goodsVO");

		int order_goods_qty = Integer.valueOf(orderVO.getOrder_goods_qty());
		int goods_price = Integer.valueOf(goodsVO.getGoods_price());
		int discounted_price = (goods_price / 10) * order_goods_qty;
		int total_goods_price = goods_price * order_goods_qty;
		int final_total_price=(int) ((total_goods_price*0.9)+3000);
		orderVO.setFinal_total_price(final_total_price);
		mav.addObject("total_goods_price", total_goods_price);
		mav.addObject("discounted_price", discounted_price);
		orderVO.setTotal_goods_price(total_goods_price);
		orderVO.setGoods(goodsVO);
		
		List ordergoods = new ArrayList<>();
		ordergoods.add(orderVO);
		
		session.setAttribute("orderInfo", ordergoods);
		return mav;
	}
	
	
	@RequestMapping(value = "/orderDir.do", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView orderDir(@RequestParam(value="array[]") String[] array, HttpServletRequest request, HttpServletResponse response)throws Exception {
		request.setCharacterEncoding("UTF-8");
		System.out.println("/orderDir.do진입");
		String viewName = "${contextPath}/goods/orderGoodsForm.do";
		List dirArr = new ArrayList<>(Arrays.asList(array));
		String articleNO =(String) dirArr.get(0);
		int dirSize = dirArr.size();
		System.out.println("size: " + dirSize);
		int  total_goods_price = dirSize*1000;
		String goods_title="우리 아이 다이어리";
		List dirDetailList = new ArrayList<>();
		for(int i=0; i<dirSize; i++) {
			Map dirDetail = diaryService.diaryDetail(articleNO);
			dirDetailList.add(dirDetail);
		}
		int order_goods_qty = 1;
		Map goods = goodsService.goodsDetail("20230825");
		goodsVO =(GoodsVO)goods.get("goodsVO");
		orderVO.setGoods_id("20230825");
		List ordergoods = new ArrayList();
		orderVO.setGoods_title(goods_title);
		orderVO.setOrder_goods_qty(order_goods_qty);
		orderVO.setTotal_goods_price(total_goods_price);
		System.out.println("토탈:" + orderVO.getTotal_goods_price());
		int discounted_price = (int) (total_goods_price*0.1);
		HttpSession session=request.getSession();
		session=request.getSession();
		orderVO.setGoods(goodsVO);
		ordergoods.add(orderVO);
			System.out.println("ordergoods:" + ordergoods);
		  session.setAttribute("orderInfo", ordergoods); 
		  session.setAttribute("goods", goodsVO);
		  System.out.println("goodsVO:" + goodsVO);
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("redirect:/goods/orderGoodsForm.do");
		mav.addObject("orderInfo", ordergoods);
		mav.addObject("goods", goodsVO);
		
		return mav;
	}
	
	@RequestMapping(value="/payToOrderGoods.do" ,method = RequestMethod.POST)
	public ModelAndView payToOrderGoods(@RequestParam Map<String, String> receiverMap,
			                       HttpServletRequest request, HttpServletResponse response)  throws Exception{

		HttpSession session=request.getSession();
		//MemberVO memberVO=(MemberVO)session.getAttribute("memberInfo");
		
		 ModelAndView mav = new ModelAndView("/goods/orderResult");
		 
		List<OrderVO> myOrderList=(List<OrderVO>)session.getAttribute("orderInfo");
		
		 Object memberInfo = session.getAttribute("memberInfo");
		    if (memberInfo instanceof MemberVO) {
		    	MemberVO memberVO = (MemberVO) memberInfo;
		String member_id=memberVO.getMember_id();
		String recipient_hp = memberVO.getMember_hp1()+"-"+memberVO.getMember_hp2()+"-"+memberVO.getMember_hp3();
		String recipient_tel = memberVO.getMember_tel1()+"-"+memberVO.getMember_tel2()+"-"+memberVO.getMember_tel3();
		String deliveryAddr = receiverMap.get("member_zipcode") + receiverMap.get("member_roadAddr") + receiverMap.get("member_jibunAddr") + receiverMap.get("member_namujiAddr");
		
		System.out.println("myOrderList 확인: " + myOrderList);
		int randomNO = (int)Math.floor(Math.random()*100000000);
		String order_id = String.valueOf(randomNO);
		int total_goods_price = Integer.valueOf(receiverMap.get("total_goods_price"));
		int goods_delivery_price = Integer.parseInt(receiverMap.get("goods_delivery_price"));
		int final_total_price = total_goods_price + goods_delivery_price;
		GoodsVO goodsVO = (GoodsVO)session.getAttribute("goods");
		List myOrderList_ = new ArrayList<>();
		for(int i=0; i<myOrderList.size();i++){
			//추가
			OrderVO orderVO = new OrderVO();
	         orderVO=(OrderVO)myOrderList.get(i);
	         orderVO.setOrder_id(order_id);   
	         orderVO.setMember_id(member_id);
	         orderVO.setRecipient_hp(recipient_hp);
	         orderVO.setRecipient_tel(recipient_tel);
	         orderVO.setDeliveryAddr(deliveryAddr);
	         orderVO.setDeliveryMessage(receiverMap.get("deliveryMessage"));
	         orderVO.setPayment_method(receiverMap.get("pay_method"));
	         orderVO.setCard_com_name(receiverMap.get("card_com_name"));
	         orderVO.setTotal_goods_price( orderVO.getOrder_goods_qty() * orderVO.getGoods().getGoods_price() );
	         orderVO.setOrder_goods_qty(orderVO.getOrder_goods_qty());
	         orderVO.setFinal_total_price(final_total_price);
	         String goods_id = orderVO.getGoods_id();

	         goodsVO = goodsDAO.getGoods(goods_id);
	         int order_goods_qty = orderVO.getOrder_goods_qty();
	         orderService.stock(Integer.parseInt(goods_id), order_goods_qty );
	         Map<String, Object> updateMap = new HashMap<>();
	         updateMap.put("goods_id", Integer.parseInt(goods_id));
	         updateMap.put("order_goods_qty", order_goods_qty);

	         // OrderService의 updateBuycntByGoodsId 메서드를 호출하여 buycnt를 업데이트
	         orderService.updateBuycntByGoodsId(updateMap);
            myOrderList_.add(orderVO); 
		}//end for
	
		
		orderService.addNewOrder(myOrderList);
		
		 mav.addObject("total_goods_price", total_goods_price);
		 mav.addObject("goods", goodsVO);
		 mav.addObject("myOrderList", myOrderList);
		session.removeAttribute("orderInfo");
		session.removeAttribute("goods");
		
		}  else if (memberInfo instanceof SellerVO) {
			SellerVO sellerVO = (SellerVO) memberInfo;
			String member_id=sellerVO.getSeller_id();
			String recipient_hp = sellerVO.getSeller_hp1()+"-"+sellerVO.getSeller_hp2()+"-"+sellerVO.getSeller_hp3();
			String recipient_tel = sellerVO.getSeller_tel1()+"-"+sellerVO.getSeller_tel2()+"-"+sellerVO.getSeller_tel3();
			String deliveryAddr = receiverMap.get("member_zipcode") + receiverMap.get("member_roadAddr") + receiverMap.get("member_jibunAddr") + receiverMap.get("member_namujiAddr");
			
			System.out.println("myOrderList 확인: " + myOrderList);
			int randomNO = (int)Math.floor(Math.random()*100000000);
			String order_id = String.valueOf(randomNO);
			int total_goods_price = Integer.valueOf(receiverMap.get("total_goods_price"));
			int goods_delivery_price = Integer.parseInt(receiverMap.get("goods_delivery_price"));
			int final_total_price = total_goods_price + goods_delivery_price;
			GoodsVO goodsVO = (GoodsVO)session.getAttribute("goods");
			for(int i=0; i<myOrderList.size();i++){
				//추가
				OrderVO orderVO = new OrderVO();
		         orderVO=(OrderVO)myOrderList.get(i);
		         orderVO.setOrder_id(order_id);   
		         orderVO.setMember_id(member_id);
		         orderVO.setRecipient_hp(recipient_hp);
		         orderVO.setRecipient_tel(recipient_tel);
		         orderVO.setDeliveryAddr(deliveryAddr);
		         orderVO.setDeliveryMessage(receiverMap.get("deliveryMessage"));
		         orderVO.setPayment_method(receiverMap.get("pay_method"));
		         orderVO.setCard_com_name(receiverMap.get("card_com_name"));
		         orderVO.setTotal_goods_price( orderVO.getOrder_goods_qty() * orderVO.getGoods().getGoods_price() );
		         orderVO.setOrder_goods_qty(orderVO.getOrder_goods_qty());
		         orderVO.setFinal_total_price(final_total_price);
		         String goods_id = orderVO.getGoods_id();

		         goodsVO = goodsDAO.getGoods(goods_id);
		         int order_goods_qty = orderVO.getOrder_goods_qty();
		         orderService.stock(Integer.parseInt(goods_id), order_goods_qty );
		         Map<String, Object> updateMap = new HashMap<>();
		         updateMap.put("goods_id", Integer.parseInt(goods_id));
		         updateMap.put("order_goods_qty", order_goods_qty);
		         orderService.updateBuycntByGoodsId(updateMap);
				myOrderList.set(i, orderVO); 
			}//end for
			
			
			orderService.addNewOrder(myOrderList);
			
			 mav.addObject("total_goods_price", total_goods_price);
			 mav.addObject("goods", goodsVO);
			 mav.addObject("myOrderList", myOrderList);
			session.removeAttribute("orderInfo");
			session.removeAttribute("goods");
		}
		    return mav;
	}
	
	
	
	
	//장바구니 > 구매하기 추가중
	@RequestMapping(value="/cartOrder.do" , method=RequestMethod.POST)
	public ModelAndView cartOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    System.out.println("/cartOrder.do 실행");

	    request.setCharacterEncoding("utf-8");
	    HttpSession session = request.getSession();
	    ModelAndView mav = new ModelAndView("/goods/orderGoodsForm");
	   

	    String[] goods_ids = request.getParameterValues("selected_goods_id");
	    String[] order_goods_qty = request.getParameterValues("selected_quantity");
	    String[] _goods_option = request.getParameterValues("selected_option");
	    
	   
	    if (goods_ids != null) {
	        List<OrderVO> ordergoods = new ArrayList<>();
	        int total_goods_price = 0;
	        int total_discounted_price = 0;
	        
	        int discounted_price=0;
	        for (int i = 0; i < goods_ids.length; i++) {

	            String goods_id = goods_ids[i];
	            String order_qty = order_goods_qty[i];
	            String goods_option = _goods_option[i];
	            System.out.println("Cart->Order Data: " + goods_id + ", Quantity: " + order_qty + ", Option: " + goods_option);

	            Map<String, Object> goodsVO1 = goodsService.goodsDetail(goods_id);
	            GoodsVO goodsVO = (GoodsVO) goodsVO1.get("goodsVO");
	            String goods_title = goodsVO.getGoods_title();
	            String goods_image_name = goodsVO.getGoods_image_name1();
	            System.out.println("상품명: " + goods_title);
	            
	            

	            int order_goods_qty1 = Integer.valueOf(order_qty);
	            int _goods_price = Integer.valueOf(goodsVO.getGoods_price());
	            discounted_price = (_goods_price / 10) * order_goods_qty1;
	            int _total_goods_price = _goods_price * order_goods_qty1;
	           
	            System.out.println("할인금액: " + discounted_price);
	            
	            
	            total_goods_price += _total_goods_price;
	            total_discounted_price += discounted_price;
	            
	            mav.addObject("order", goods_option);

	            OrderVO orderVO = new OrderVO();
	            orderVO.setGoods_id(goods_id);
	            orderVO.setGoods_option(goods_option);
	            orderVO.setOrder_goods_qty(order_goods_qty1);
	            orderVO.setGoods_image_name("goods_image_name");
	            orderVO.setGoods_title(goods_title);
	            goodsVO.setGoods_delivery_price(3000);
	            
	            orderVO.setGoods(goodsVO);
		        mav.addObject("total_goods_price", total_goods_price);
		        
	            ordergoods.add(orderVO); // OrderVO 객체 리스트에 추가
	            
	            
	        }
			int final_total_price=(int) ((total_goods_price*0.9)+3000);
			ordergoods.get(0).setFinal_total_price(final_total_price);
	       // total_discounted_price = (discounted_price*(goods_ids.length));
	        System.out.println("총할인: " + total_discounted_price);
	        mav.addObject("discounted_price", total_discounted_price);
	        
	        session.setAttribute("orderInfo", ordergoods);
	       
	        
	    } else {
	        System.out.println("선택된 상품이 없습니다.");
	    }
	    
	   
	    return mav;
	}
}


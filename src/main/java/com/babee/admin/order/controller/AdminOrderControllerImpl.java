package com.babee.admin.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.babee.admin.order.service.AdminOrderService;
import com.babee.common.base.BaseController;
import com.babee.diary.service.DiaryService;
import com.babee.diary.vo.DiaryVO;
import com.babee.order.vo.OrderVO;

@Controller("adminOrderController")
@RequestMapping(value="/admin/order")
public class AdminOrderControllerImpl extends BaseController  implements AdminOrderController{
	@Autowired
	private AdminOrderService adminOrderService;
	@Autowired
	private DiaryService diaryService;
	@Autowired
	private DiaryVO diaryVO;
	
	@Override
	@RequestMapping(value="/adminOrderMain.do" ,method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView adminOrderMain(@RequestParam Map<String, String> dateMap,
			                          HttpServletRequest request, HttpServletResponse response)  throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);

		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String section = dateMap.get("section");
		String pageNum = dateMap.get("pageNum");
		String search_type = dateMap.get("search_type");
		String search_word = dateMap.get("search_word");
		String beginDate=null,endDate=null;
		
		String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
		beginDate=tempDate[0];
		endDate=tempDate[1];
		dateMap.put("beginDate", beginDate);
		dateMap.put("endDate", endDate);
		
		
		HashMap<String,Object> condMap=new HashMap<String,Object>();
		if(section== null) {
			section = "1";
		}
		condMap.put("section",section);
		if(pageNum== null) {
			pageNum = "1";
		}
		condMap.put("pageNum",pageNum);
		condMap.put("beginDate",beginDate);
		condMap.put("endDate", endDate);
		condMap.put("search_type", search_type);
		condMap.put("search_word", search_word);
		List<OrderVO> newOrderList=adminOrderService.listNewOrder(condMap);
		mav.addObject("newOrderList",newOrderList);
		
		String beginDate1[]=beginDate.split("-");
		String endDate2[]=endDate.split("-");
		mav.addObject("beginYear",beginDate1[0]);
		mav.addObject("beginMonth",beginDate1[1]);
		mav.addObject("beginDay",beginDate1[2]);
		mav.addObject("endYear",endDate2[0]);
		mav.addObject("endMonth",endDate2[1]);
		mav.addObject("endDay",endDate2[2]);
		
		mav.addObject("section", section);
		mav.addObject("pageNum", pageNum);
		return mav;
		
	}
	
	@Override
	@RequestMapping(value="/modifyDeliveryState.do" ,method={RequestMethod.POST})
	public ResponseEntity modifyDeliveryState(@RequestParam Map<String, String> deliveryMap, 
			                        HttpServletRequest request, HttpServletResponse response)  throws Exception {
		adminOrderService.modifyDeliveryState(deliveryMap);
		
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message  = "mod_success";
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
		
	}
	
	@Override
	@RequestMapping(value="/orderDetail.do" ,method={RequestMethod.GET,RequestMethod.POST})
	public ModelAndView orderDetail(@RequestParam("order_id") int order_id, 
			                      HttpServletRequest request, HttpServletResponse response)  throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		Map orderMap =adminOrderService.orderDetail(order_id);
		mav.addObject("orderMap", orderMap);
		return mav;
	}
	
	@Override
	@RequestMapping(value="/diaryManageList.do" ,method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView diaryManageList(HttpServletRequest request, HttpServletResponse response)  throws Exception {
		System.out.println("diaryManageList.do 실행");
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView(viewName);
		HttpSession session=request.getSession();
		String _section = request.getParameter("section"); 
		String _pageNum = request.getParameter("pageNum"); 
		int section =Integer.parseInt(((_section==null)? "1":_section)); 
		int pageNum = Integer.parseInt(((_pageNum==null)? "1":_pageNum));
		
		
		
		List diaryManageList = new ArrayList<>();
		List diaryManage = diaryService.allDiaryList();
		int ListSize = diaryManage.size();
		System.out.println("ListSize: " + ListSize);
		for(int i =(pageNum-1)*10; i <pageNum*10; i++) {
			try {
				diaryVO = (DiaryVO) diaryManage.get(i);
				diaryManageList.add(diaryVO);
			}catch(IndexOutOfBoundsException e) {
				break;
			}
			}
		System.out.println("diaryManageList: " + diaryManageList);
		mav.addObject("diaryManageList", diaryManageList);
		mav.addObject("section", section);
		mav.addObject("pageNum", pageNum);
		mav.addObject("totArticles", ListSize);
		mav.setViewName("/admin/order/diaryManageList");
		
		return mav;
	}
	
	
	
}

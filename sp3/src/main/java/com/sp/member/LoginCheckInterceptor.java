package com.sp.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/*
  * HandlerInterceptor 인터페이스
    - 컨트롤러가 요청하기 전과 후에 알 맞는 기능을 수행 할 수 있도록 하기 위한 인터페이스
    - 다수의 인터셉터가 설 정 된 경우 (a, b, c 인터셉터가 설정된경우)
      1) a 의 preHandle(),  b 의 preHandle(), c 의 preHandle() 실행
      2) 컨트롤러의 handleRequest() 메소드 실행
      3) c 의 postHandle(),  b 의 postHandle(), a 의 postHandle() 실행
      4) 뷰 객체의 render() 메소드 실행
      5) c 의 afterCompletion(),  b 의 afterCompletion(), a 의 afterCompletion() 실행
    - 로그인 검사, 응답 시간 계산, 이벤트기간 만료등에서 이용하면 편리
  
  * 인터셉터를 적용하기 위해서는 아래와 같이 HandlerInterceptor를 등록 해야 한다.
       특정 패턴의 url에만 인터셉터를 적용하기 위해서는 <mvc:interceptors>태그 내부에 <mvc:interceptor>를 사용한다. 
      <mvc:mapping path="/member/**" />
      <mvc:mapping path="/bbs/**" />
       처럼 여러개를 설정 할 수 있다.

    <mvc:interceptors>
      <mvc:interceptor>
          <mvc:mapping path="/**" />
        
          <mvc:exclude-mapping path="/"/>
          <mvc:exclude-mapping path="/member"/>
          <bean class="com.sp.member.LoginCheckInterceptor"/>
      </mvc:interceptor>
    </mvc:interceptors>
  
  * interceptor에 특정 URL Pattern을 제외하여 맵핑하는 기능도 지원하고 있다.
       이 때는 <mvc:interceptor>내부에서 <exclude-mapping>태그를 사용한다.
    <exclude-mapping>는  <mvc:mapping> 아래부분에 설정한다.
*/

public class LoginCheckInterceptor extends HandlerInterceptorAdapter {
	/*
	   클라이언트 요청이 컨트롤러에 도착하기 전에 호출 
	       false를 리턴하면 HandlerInterceptor 또는 컨트롤러를 실행하지 않고 요청 종료
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		boolean result = true;
		
		try {
			HttpSession session = request.getSession();
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			String cp = request.getContextPath();
			String uri = request.getRequestURI();
			String queryString = request.getQueryString(); //GET방식 쿼리스트링 (query = (?)) 
			
			if(info!=null) {
				return result; 
			}
			
			result= false;
			if(isAjaxRequest(request)) {
				response.sendError(403);
			}else {
				if(uri.indexOf(cp)==0) {
					uri=uri.substring(cp.length());
				}
				if(queryString!=null) {
					uri+="?"+queryString;
				}
				session.setAttribute("preLoginURI", uri);
				response.sendRedirect(cp+"/member/login");
			}
			
			
		} catch (Exception e) {
		}
		
		return result;
	}
	
	
	// AJAX 요청인지를 확인하기 위한 메소드 
	// AJAX 로 요청할 때 header에 AJAX:true를 추가해서 요청
	private boolean isAjaxRequest(HttpServletRequest req) {
		String h = req.getHeader("AJAX");
		return h!=null && h.equals("true");
	}
	
	
	

	/*
	   컨트롤러가 요청을 처리 한 후에 호출. 컨트롤러 실행 중 예외가 발생하면 실행 하지 않음  
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		super.postHandle(request, response, handler, modelAndView);
	}

	/*
	  클라이언트 요청을 처리한 뒤, 즉 뷰를 통해 클라이언트에 응답을 전송한 뒤에 실행
	  컨트롤러 처리 중 또는 뷰를 생성하는 과정에 예외가 발생해도 실행  
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		super.afterCompletion(request, response, handler, ex);
	}

}

package com.sp.workMng;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.sp.guest.Guest;
import com.sp.member.SessionInfo;
import com.sp.notice.Notice;


@Controller("workMng.workMngController")
@RequestMapping("/workMng/*")
public class WorkMngController {
	
	@Autowired
	private WorkMngService workMngService;
	
	@RequestMapping(value="dashboard")
	public String method() {
		// 화면 로드시 공공 api 데이터 가져오기  
		return ".workMng.dashboard";
	}

	// 날짜 ('yyyymmdd' 형태) return 
	public String getdate(String divCd) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        
        if(divCd.equals("Y")) {
        	cal.add(Calendar.DATE,-1);
        }
        String day = sdf.format(cal.getTime());
        return day;
	}

	// 날짜 ('yyyymmdd' 형태) return 
	public String getBeforedate(String divCd) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        
        if(divCd.equals("Y")) {
        	cal.add(Calendar.DATE,-1);
        }

        if(divCd.equals("B")) {
        	cal.add(Calendar.DATE,-3);
        }
        String day = sdf.format(cal.getTime());
        return day;
	}
	
	// 현재 시간 '0-24 시간 형태'
	public String getNowTime(String divCd) {
        SimpleDateFormat sdf = new SimpleDateFormat("hhmm");
        Calendar cal = Calendar.getInstance();

        if(divCd.equals("Y")) {
        	cal.add(Calendar.HOUR_OF_DAY, +6);
        }
        
        String day = sdf.format(cal.getTime());
        return day;
	}
	
	// xml 파싱 태그명 가져오기 
	public String getTagValue(String tag, Element eElement) {
		NodeList nList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
		Node nValue = (Node)nList.item(0);
		if(nValue == null) {
			return null;
		}
		return nValue.getNodeValue();
	}
	
	// 코로나 api 호출 메서드
	public NodeList getValue(String beforeDiv) {
		NodeList nList = null;
		try {
	        StringBuilder urlBuilder = new StringBuilder("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson"); /*URL*/
	        String serviceKey = "=oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D";
	        
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + serviceKey); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*한 페이지 결과 수*/

	        String yesterday = beforeDiv.equals("B") ? getBeforedate("B") : getBeforedate("Y");
	        urlBuilder.append("&" + URLEncoder.encode("startCreateDt","UTF-8") + "=" + URLEncoder.encode(yesterday, "UTF-8")); /*검색할 생성일 범위의 시작*/
	        urlBuilder.append("&" + URLEncoder.encode("endCreateDt","UTF-8") + "=" + URLEncoder.encode(yesterday, "UTF-8")); /*검색할 생성일 범위의 종료*/

	        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
	        DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
	        Document document = (Document) documentBuilder.parse(urlBuilder.toString());

	        System.out.println("url : " + urlBuilder.toString());
	        document.getDocumentElement().normalize();
	        nList = document.getElementsByTagName("item");
		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		return nList;
	}

	// 코로나 정보 API parsing, return
	@RequestMapping(value="getCovidData", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> getCovidData() {
		Map<String, String> covidMap = new HashMap<>();
		try {
	        //어제 
			NodeList nList = getValue("B");
	        
	        for(int i=0; i<nList.getLength(); i++) {
	        	Node itemNode = nList.item(i);
	        	if(itemNode.getNodeType() == Node.ELEMENT_NODE) {
	        		Element eElement = (Element) itemNode;
	        		System.out.println("전전일 확진자수  : " + getTagValue("decideCnt", eElement));
	        		System.out.println("기준일자  : " + getTagValue("stateDt", eElement));
	    	        covidMap.put("beforeDecideCnt", getTagValue("decideCnt", eElement)); // 확진자수
	        	}
	        }
	        
	        // 오늘 
			nList = getValue("Y");
	        for(int i=0; i<nList.getLength(); i++) {
	        	Node itemNode = nList.item(i);
	        	if(itemNode.getNodeType() == Node.ELEMENT_NODE) {
	        		Element eElement = (Element) itemNode;
	        		System.out.println("전일 확진자수  : " + getTagValue("decideCnt", eElement));
	        		System.out.println("기준일자  : " + getTagValue("stateDt", eElement));
	    	        covidMap.put("decideCnt", getTagValue("decideCnt", eElement)); // 확진자수
	    	        covidMap.put("stateDt", getTagValue("stateDt", eElement)); // 기준일자
	        	}
	        }
	        
	        covidMap.put("result", "success");
		}catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		return covidMap;
	}
	
	// 날씨 API
	@RequestMapping(value="getWeatherData", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> getWeatherData() {
		
		StringBuilder sb = new StringBuilder();
		Map<String, String> weatherMap = new HashMap<String, String>();
		
		try {
		    
		    String serviceKey = "=oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D";
		    String day = getdate("T");
		    String nowTime = getNowTime("T");

	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddkk");
	        String sfdDt = sdf.format(new Date());
	        Date date1 = sdf.parse(sfdDt);
	        
	        Calendar cal = Calendar.getInstance();
	        Calendar nowCal = Calendar.getInstance();
	        cal.setTime(date1);
	        cal.set(Calendar.HOUR_OF_DAY, 24);
	        System.out.println("##cal ::: " + cal);
	        System.out.println(nowCal.after(cal));
	        if(nowCal.after(cal)) {
	        	day = getdate("Y");
	        	nowTime = getNowTime("Y");
	        }
	        
		    boolean dataNullChk = false;
	        
	        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"); /*URL*/
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + serviceKey); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8")); /*한 페이지 결과 수*/
	        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
	        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(day, "UTF-8")); /*‘21년 6월 28일 발표*/
	        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(nowTime, "UTF-8")); /*06시 발표(정시단위) */
	        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode("55", "UTF-8")); /*예보지점의 X 좌표값*/
	        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode("127", "UTF-8")); /*예보지점의 Y 좌표값*/
	        
	        System.out.println(urlBuilder.toString());
	        URL url = new URL(urlBuilder.toString());
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        System.out.println("Response code: " + conn.getResponseCode());
	        BufferedReader rd;
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
	        	dataNullChk = true;
	        	weatherMap.put("result", "fail");
	        }
	        String line;
	        while ((line = rd.readLine()) != null) {
	        	sb.append(line);
		        System.out.println(sb.toString());
	        }

	        rd.close();
	        conn.disconnect();
	        
	        if(! dataNullChk ) {
		        JSONParser jsonParser = new JSONParser();
		        JSONObject jsonObject = (JSONObject) jsonParser.parse(sb.toString());
		        JSONObject jsonObject_res = (JSONObject) jsonObject.get("response");
		        JSONObject jsonObject_body = (JSONObject) jsonObject_res.get("body");
		        JSONObject jsonObject_items = (JSONObject) jsonObject_body.get("items");
	
		        JSONArray jsonArr = (JSONArray) jsonObject_items.get("item");
		       
		        for(int i=0; i<jsonArr.size(); i++) {
		        	JSONObject item = (JSONObject) jsonArr.get(i);
		            String category = (String)item.get("category");
		            String weather = "";
		            String obsrValue = "";
		            
		            if(category.equals("SKY")){
		            	obsrValue = (String)item.get("obsrValue");
		                if(obsrValue.equals("1")) {
		                    weather += "맑음";
		                }else if(obsrValue.equals("2")) {
		                    weather += "비";
		                }else if(obsrValue.equals("3")) {
		                    weather += "구름이 많음";
		                }else if(obsrValue.equals("4")) {
		                    weather += "흐림 ";
		                }
		                weatherMap.put("weather", weather);
		                System.out.println("weather : " + weather);
		            }
	
		            if(category.equals("T1H")){
		            	obsrValue = (String)item.get("obsrValue");
		            	weatherMap.put("tmperature", obsrValue);
		                System.out.println("tmperature : " + obsrValue);
		            }
		            
		            if(category.equals("PTY")){
		            	obsrValue = (String)item.get("obsrValue");
		            	weatherMap.put("rain", obsrValue);
		            	System.out.println("rain : " + obsrValue);
		            }
		        }
	        	weatherMap.put("result", "success");
	        }

		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		
		return weatherMap;
	}
	
	// 대시보드 리스트 출력 
	@RequestMapping(value="selectList", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(
			HttpSession session 
			) throws Exception{

		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String userId = info.getUserId(); 
		
		List<WorkMng> todoList =workMngService.selectTodoList(userId);
		List<WorkMng> planList =workMngService.selectPlanList(userId);
		List<WorkMng> memoList =workMngService.selectMemoList(userId);
		
		Map<String, Object> result = new HashMap<>();
		result.put("todoList", todoList);
		result.put("planList", planList);
		result.put("memoList", memoList);
		
		return result;
	}
	
	// 할일 작성 화면 호출 
	@RequestMapping(value="createTodoList", method=RequestMethod.GET)
	public String createdForm(
			Model model,
			HttpSession session
			) throws Exception {
		return ".workMng.createTodoList";
	}

	// 할일 신규 등록
	@RequestMapping(value="insertList", method=RequestMethod.POST)
	public String createdSubmit(
			WorkMng dto,
			HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String userId = info.getUserId(); 
		dto.setUserId(userId);
		
		if(dto.getSaveDiv().equals("T")) {
			if(dto.getImportance() == null) {
				dto.setImportance("X");
			}
			workMngService.insertTodoList(dto);
		}else if(dto.getSaveDiv().equals("P")) {
			workMngService.insertPlan(dto);
		}else if(dto.getSaveDiv().equals("M")) {
			workMngService.insertMemo(dto);
		}
		
		return "redirect:/workMng/dashboard";
	}
	
	// 할일 삭제
	@RequestMapping(value="deleteList", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteTodoList(
			@RequestParam int num,
			@RequestParam String saveDiv,
			HttpSession session) throws Exception {

		Map<String, Object> map = new HashMap<>();

		if(saveDiv.equals("T")) {
			workMngService.deleteTodoList(num);
		}else if(saveDiv.equals("P")) {
			workMngService.deletePlan(num);
		}else if(saveDiv.equals("M")) {
			workMngService.deleteMemo(num);
		}
		
		map.put("result", "success");
		return map;
	}
	
	// plan 작성 화면 호출 
	@RequestMapping(value="createPlanList", method=RequestMethod.GET)
	public String createdPlanForm(
			Model model,
			HttpSession session
			) throws Exception {
		return ".workMng.createPlanList";
	}
	
	// 메모 작성 화면 호출 
	@RequestMapping(value="createMemoList", method=RequestMethod.GET)
	public String createdMemoForm(
			Model model,
			HttpSession session
			) throws Exception {
		return ".workMng.createMemoList";
	}
	
	// 메모 내용 조회 화면 호출 
	@RequestMapping(value="selectMemoContents", method=RequestMethod.GET)
	public String selectMemoContents(
			Model model,
			@RequestParam int memoNum
			) throws Exception {
		
		WorkMng dto = workMngService.selectMemoContent(memoNum);
		model.addAttribute("dto", dto);
		return ".workMng.memoView";
	}
}

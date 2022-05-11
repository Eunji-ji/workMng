package com.sp.workMng;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("workMng.workMngController")
@RequestMapping("/workMng/*")
public class WorkMngController {
	
	@RequestMapping(value="dashboard")
	public String method(Model model) {
		// 화면 로드시 공공 api 데이터 가져오기  
		model.addAttribute("covid", getCovidData()); // 코로나 
		model.addAttribute("weather", getWeatherData()); // 날씨
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

	// 현재 시간 '0-24 시간 형태'
	public String getNowTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("hh");
        Calendar cal = Calendar.getInstance();
        String day = sdf.format(cal.getTime());
        return day;
	}
	
	// 코로나 정보 API
	public String getCovidData() {
		StringBuilder sb = new StringBuilder();
		try {
			
	        StringBuilder urlBuilder = new StringBuilder("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson"); /*URL*/
	        String serviceKey = "=oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D";
	        
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + serviceKey); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*한 페이지 결과 수*/

	        String yesterday = getdate("Y");
	        urlBuilder.append("&" + URLEncoder.encode("startCreateDt","UTF-8") + "=" + URLEncoder.encode(yesterday, "UTF-8")); /*검색할 생성일 범위의 시작*/
	        urlBuilder.append("&" + URLEncoder.encode("endCreateDt","UTF-8") + "=" + URLEncoder.encode(yesterday, "UTF-8")); /*검색할 생성일 범위의 종료*/
	        
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
	        }

	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        System.out.println(sb.toString());
		}catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		return sb.toString();
	}
	
	// 날씨 API
	public Map<String, String> getWeatherData() {
		
		StringBuilder sb = new StringBuilder();
		Map<String, String> weatherMap = new HashMap<String, String>();
		
		try {
		    
		    String serviceKey = "=oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D";
		    String day = getdate("Y");
	        
	        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"); /*URL*/
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + serviceKey); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8")); /*한 페이지 결과 수*/
	        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
	        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(day, "UTF-8")); /*‘21년 6월 28일 발표*/
	        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode("0600", "UTF-8")); /*06시 발표(정시단위) */
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
	        }
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        System.out.println(sb.toString());
	        
	        // response 키를 가지고 데이터를 파싱
	        JSONObject jsonObj_1 = new JSONObject(sb.toString());
	        JSONObject response = jsonObj_1.getJSONObject("response");
	        
	        System.out.println(response);
	        
	        // response 로 부터 body 찾기
	        JSONObject jsonObj_2 = new JSONObject(response);
	        JSONObject body = jsonObj_2.getJSONObject("body");

	        // body 로 부터 items 찾기
	        JSONObject jsonObj_3 = new JSONObject(body);
	        JSONObject items = jsonObj_3.getJSONObject("items");

	        // items로 부터 itemlist 를 받기 
	        JSONObject jsonObj_4 = new JSONObject(items);
	        JSONArray jsonArray = jsonObj_4.getJSONArray("item");

	        for(int i=0;i<jsonArray.length();i++){
	            jsonObj_4 = jsonArray.getJSONObject(i);
	            String category = jsonObj_4.getString("category");
	            String obsrValue = jsonObj_4.getString("obsrValue");
	            String weather = "";

	            if(category.equals("SKY")){
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
	            	weatherMap.put("tmperature", obsrValue);
	                System.out.println("tmperature : " + obsrValue);
	            }
	            
	            if(category.equals("PTY")){
	            	weatherMap.put("rain", obsrValue);
	            	System.out.println("rain : " + obsrValue);
	            }
	        }
		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		return weatherMap;
	}
}

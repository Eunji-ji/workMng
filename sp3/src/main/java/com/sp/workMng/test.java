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

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class test {
	
	// 날짜 ('yyyymmdd' 형태) return 
	public static String getdate(String divCd) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        
        if(divCd.equals("Y")) {
        	cal.add(Calendar.DATE,-1);
        }
        String day = sdf.format(cal.getTime());
        return day;
	}
	
	// xml 파싱 태그명 가져오기 
	public static String getTagValue(String tag, Element eElement) {
		NodeList nList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
		Node nValue = (Node)nList.item(0);
		if(nValue == null) {
			return null;
		}
		return nValue.getNodeValue();
	}	
	
	public static void main(String[] args) {

		Map<String, String> covidMap = new HashMap<>();
		
		try {
	        StringBuilder urlBuilder = new StringBuilder("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson"); /*URL*/
	        String serviceKey = "=oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D";
	        
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + serviceKey); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*한 페이지 결과 수*/

	        String yesterday = getdate("Y");
	        urlBuilder.append("&" + URLEncoder.encode("startCreateDt","UTF-8") + "=" + URLEncoder.encode(yesterday, "UTF-8")); /*검색할 생성일 범위의 시작*/
	        urlBuilder.append("&" + URLEncoder.encode("endCreateDt","UTF-8") + "=" + URLEncoder.encode(yesterday, "UTF-8")); /*검색할 생성일 범위의 종료*/

	        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
	        DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
	        Document document = (Document) documentBuilder.parse(urlBuilder.toString());

	        System.out.println("url : " + urlBuilder.toString());
	        document.getDocumentElement().normalize();
	        NodeList nList = document.getElementsByTagName("item");
	        
	        for(int i=0; i<nList.getLength(); i++) {
	        	Node itemNode = nList.item(i);
	        	if(itemNode.getNodeType() == Node.ELEMENT_NODE) {
	        		Element eElement = (Element) itemNode;
	        		System.out.println("확진자수  : " + getTagValue("decideCnt", eElement));
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
	}
}



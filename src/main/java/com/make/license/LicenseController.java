package com.make.license;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.make.common.Common;

@Controller
public class LicenseController {

	@RequestMapping("/License.do")
	public String License(@RequestParam("license") String license, HttpServletRequest req) {

		license = license.replaceAll("<br>", "\n");
		license = license.replaceAll("<plus>", "+");
		System.out.println("license : " + license);

		req.setAttribute("licenseReq", license);


		try {
			File file = new File("F:\\License");
			//파일 존재여부 체크 및 생성            
			if (!file.exists()) {   
				file.createNewFile(); 
//			} else {
//				int seq = 1;
//				while(file.exists()) {
//					String fileName = "License_"+seq++;
//					file = new File("F:\\"+fileName);
//					
//				}
//				file.createNewFile(); 
				
			}
			 //Buffer를 사용해서 File에 write할 수 있는 BufferedWriter 생성
			FileWriter fw = new FileWriter(file);
			BufferedWriter writer = new BufferedWriter(fw);
			//파일에 쓰기
			writer.write(license);
			//BufferedWriter close
			writer.close();
			
			
//			//xml 문서 파싱
//			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//			//DocumentBuilder builder = factory.newDocumentBuilder();
//			DocumentBuilder parser = factory.newDocumentBuilder();
//			Document doc = parser.newDocument();
//		
//			//doc.setTextContent(license);
//			//xml 생성 > license 값 넣기
//			//Document doc = builder.parse(new InputSource(new StringReader(license)));
//
//			//transformer 객체 생성
//			TransformerFactory transformerFactory = TransformerFactory.newInstance();
//			Transformer transformer = transformerFactory.newTransformer();
//			
//			//dom 객체로 저장
//			DOMSource DOMsource = new DOMSource(doc);
//
//			StreamResult result =  new StreamResult(new File("F:\\License"));
//			transformer.transform(DOMsource, result);
//			
//			System.out.println("완료");
			
		}

		catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
	
		return "makeLicense";
		
	}
}

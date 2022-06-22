package com.make.license;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SendMailController {

	@RequestMapping("sendMail.do")
	@ResponseBody
	public String sendMail(HttpServletRequest req, HttpServletResponse response, Model model,
						@RequestParam("fromEmail") String fromEmail, @RequestParam("fromPasswd") String fromPasswd, @RequestParam("fromName") String fromName,
						@RequestParam("toEmail") String toEmail, @RequestParam("toCompany") String toCompany,
						@RequestParam("cpu") String cpu, @RequestParam("ip") String ip, @RequestParam("type") String type) {

		Properties propt = new Properties(); // properties  : map 계열

		propt.put("mail.smtp.host", "smtp.gmail.com");
		propt.put("mail.smtp.port", "587");
		propt.put("mail.smtp.auth", "true");
		propt.put("mail.smtp.starttls.enable", "true");
		propt.put("mail.smtp.ssl.trust", "smtp.gmail.com");

		/*
	 	javax.mail.MessagingException: Could not convert socket to TLS;
  		nested exception is:
		javax.net.ssl.SSLHandshakeException: No appropriate protocol (protocol is disabled or cipher suites are inappropriate)
		 */
		propt.put("mail.smtp.ssl.protocols", "TLSv1.2");


		Session session = Session.getInstance(propt, new Authenticator() { // 인증 정보 session 저장

			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(fromEmail, fromPasswd);
			}
		});

		

		String content ="안녕하세요. 인스웨이브 " + fromName + "입니다.\n\n"
				+ "요청하신 프로웍스 " + type +" 라이선스 전달 드립니다. \n\n"
				+ "======================================\n\n"
				+ ip + " (cpu=" + cpu + ")\n\n";
		try {
			BufferedReader reader = new BufferedReader(
					new FileReader("F:\\License")
			);
			String str;
			System.out.println("읽는다");
			while ((str = reader.readLine()) != null) {
				System.out.println(str);
				content += str +"\n";
				}
			content += "\n======================================\n\n감사합니다.";
			reader.close();
			BodyPart attachment = new MimeBodyPart();
			
			/*
			javax.mail.MessagingException: IOException while sending message;
		  	nested exception is:
			java.io.IOException: No content
			at com.sun.mail.smtp.SMTPTransport.sendMessage(SMTPTransport.java:930)
			 */
			attachment.setFileName("License"); 
			attachment.setDataHandler(new DataHandler(new FileDataSource(new File("F:\\License"))));
			
			BodyPart body = new MimeBodyPart();
			body.setText(content);
			
			
			MimeMultipart multipart = new MimeMultipart();
			multipart.addBodyPart(body);
			multipart.addBodyPart(attachment);

			String subject = "[" + toCompany + "] 프로웍스 " + type + "라이선스 전달"; 
			
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(fromEmail));
			msg.addRecipient(Message.RecipientType.TO, 
					new InternetAddress(toEmail));
			msg.setSubject(subject);
			msg.setContent(multipart);
			Transport.send(msg);
			System.out.println("메일 전송 성공");
		} catch (FileNotFoundException e1) {
			System.out.println("Exception [FileNotFoundException]");
			e1.printStackTrace();
		} catch (IOException e) {
			System.out.println("Exception [IOException]");
			e.printStackTrace();
		} catch (AddressException e) {
			System.out.println("Exception [AddressException]");
			e.printStackTrace();
		} catch (MessagingException e) {
			System.out.println("Exception [MessagingException]");
			model.addAttribute("authError", 1);
			e.printStackTrace();
		}
		
		return "makeLicense";	
	}
}

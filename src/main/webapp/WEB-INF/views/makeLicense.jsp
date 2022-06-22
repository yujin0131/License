<%@ page import="java.nio.charset.Charset"%>
<%@ page import="sun.misc.BASE64Decoder"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>
<%@ page contentType="text/html; charset=euc-kr" language="java"%>

<%@ page import="java.util.*"%>
<%@ page import="javax.crypto.spec.DESKeySpec"%>
<%@ page import="javax.crypto.SecretKeyFactory"%>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.SecretKey"%>
<%@ page import="sun.misc.BASE64Encoder"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
boolean Makeflag = false;
String flag = request.getParameter("Makeflag");
if (null != flag) {
	Makeflag = true;
}
String licenseID = "8204";
String isDemo = "";
String customerID = "8204";
String customerName = "";
String hostname = "";
String ip = "";
String cpuNumber = "";
String expiredate = "";
String licenseString = "";
String retval = "";
String licenseKind = "";
String websquareSoft = "";
String coverted = "";

if (Makeflag) {
	licenseKind = request.getParameter("licenseKind");
	isDemo = request.getParameter("licenseType");
	customerName = request.getParameter("customerName");
	hostname = request.getParameter("hostName");
	ip = request.getParameter("serverIp");
	cpuNumber = request.getParameter("cpuCount");
	expiredate = request.getParameter("expiredate");

	if ("proworks".equals(licenseKind)) {
		licenseString = licenseID + ":" + isDemo + ":" + customerID + ":" + customerName + ":" + expiredate + ":"
		+ hostname + ":" + ip + ":" + cpuNumber;
		licenseString += ":7:SVMS:TMS:EGMS:Operational Framework:SIMS:SMS:SVMS AGENT";
		System.out.println("licenseString : " + licenseString);
	} else {
		websquareSoft = request.getParameter("websquareSoft");
		licenseString = licenseID + ":" + customerID + ":" + customerName + ":" + isDemo + ":" + hostname + ":" + ip
		+ ":" + websquareSoft + ":" + expiredate + ":" + cpuNumber;
		licenseString += ":true:4:platform:push:studio:hybrid platform";
		System.out.println("licenseString  : " + licenseString);
	}
	StringBuffer sb = new StringBuffer();
	for (int i = 0; i < 20; i++) {
		int num = (int) (Math.random() * 43);
		sb.append((char) ('0' + (int) (Math.random() * 43)));
	}
	String licenseKeyId = sb.toString();
	System.out.println("licenseKeyId : " + licenseKeyId);
	String mySecretKeyBASE64 = "";
	byte[] key = licenseKeyId.getBytes();//byte로 저장
	byte[] originKey = new byte[20];

	if (key.length < 20) {
		System.arraycopy(key, 0, originKey, 0, key.length);
	} else {
		System.arraycopy(key, 0, originKey, 0, 20);
	}

	SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");
	SecretKey myKey = skf.generateSecret(new DESKeySpec(originKey));

	Cipher cipher = Cipher.getInstance("DES");
	cipher.init(Cipher.ENCRYPT_MODE, myKey);
	byte[] cleartext = licenseString.getBytes();
	byte[] ciphertext = cipher.doFinal(cleartext);

	BASE64Encoder encoder = new BASE64Encoder();
	String encodedLicense = encoder.encodeBuffer(ciphertext);
	String encodedLicenseKey = encoder.encodeBuffer(originKey);
	retval = encodedLicense.substring(0, 5) + encodedLicenseKey + encodedLicense.substring(5);

	System.out.println("retval : " + retval);
	System.out.println("encodedLicense : " + encodedLicense);
	System.out.println("encodedLicenseKey : " + encodedLicenseKey);

	System.out.println("============복호화============");

	String deretval = "lZVCmTkpUQjVTPENZNTM+Sz46QFlQT1c=\n";
	deretval += "26gRTgj9J5HMsqXGPuHzX0r9QAqCwb8sJi+uRP5ITrxS4MJdlhxeepyGsH7PgOsKQhm8nH8\n";
	deretval += "L6j3Hi5kivlrk02aQCsKwE5uDU/WQLcOXPtV0ZWHrthlx0IOl33b5H5rhYUAB4qh8ku1//HifA==";

	System.out.println("deretval############: " + deretval);
	String splitLicenseKey = deretval.substring(5, 34);
	StringBuilder splitLicense = new StringBuilder();
	splitLicense.append(deretval.substring(0, 5).trim());
	splitLicense.append(deretval.substring(34).trim());

	BASE64Decoder decoder = new BASE64Decoder();

	byte[] decoKey = decoder.decodeBuffer(splitLicenseKey);

	SecretKeyFactory deskf = SecretKeyFactory.getInstance("DES");
	SecretKey demyKey = skf.generateSecret(new DESKeySpec(decoKey));

	Cipher decipher = Cipher.getInstance("DES");
	decipher.init(Cipher.DECRYPT_MODE, demyKey);

	byte[] decoLicense = decoder.decodeBuffer(splitLicense.toString());
	byte[] n = decipher.doFinal(decoLicense);

	coverted = new String(n);
	System.out.println("coverted : " + coverted);

	/* 
	BASE64Decoder decoder = new BASE64Decoder();
	String decodeLicense = decoder.decodeBuffer()(ciptext);
	System.out.println("decodeLicense : " + decodeLicense); */

	//byte[] decoded = DatatypeConverter.parseBase64Binary(decodedLicense);
}
%>
<html>
<head>
<title>License 생성기</title>
<script type="text/javascript"
	src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
<script lang="javascript">
	function make() {
		var f = document.LicenseForm;
		var license = f.result.value.trim();

		license = license.replaceAll("\n", "<br>");
		license = license.replaceAll("+", "<plus>");
		alert(license);
		var url = "/License.do";
		var param = "license=" + license;
		sendRequest(url, param, resultFnmake, "POST");

	}

	function resultFnmake() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			alert("라이선스 다운 완료");
		}

	}

	function mail() {
		var fMail = document.mailForm;
		var fLicense = document.LicenseForm;
		
		var fromEmail = fMail.fromEmail.value.trim();
		var fromPasswd = fMail.fromPasswd.value.trim();
		var fromName = fMail.fromName.value.trim();
		
		var toEmail = fMail.toEmail.value.trim();
		var toCompany = fMail.toCompany.value.trim();
		
		var cpu = fLicense.cpuCount.value.trim();
		var ip = fLicense.serverIp.value.trim();
		var type = fLicense.licenseType.value.trim() == 0 ? "데모" : "영구";
		
		alert("cpu : " + cpu + " ip :" + ip + " type :" + type);
		
		var url = "/sendMail.do";
		var param = "fromEmail=" + fromEmail + "&fromPasswd=" + fromPasswd + "&fromName=" + fromName + "&toEmail=" + toEmail + "&toCompany=" + toCompany + "&cpu=" + cpu + "&ip=" + ip + "&type=" + type;
		sendRequest(url, param, resultFnmail, "POST");
	}

	function resultFnmail() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			if(${authError == 1}){
				alert("직원의 아이디, 비밀번호를 확인하세요.");
			}
		}

	}
	
	function fn_licenseType_Change() {
		var select = document.getElementById("licenseType");
		var option_value = select.options[select.selectedIndex].value;
		if (option_value == "1") {
			document.getElementById("expiredate").value = "20991231";
		} else {
			document.getElementById("expiredate").value = "";
		}
	}

	function fn_selectKind() {
		var select = document.getElementById("licenseKind");
		var option_value = select.options[select.selectedIndex].value;
		if (option_value == "websquare") {
			document.getElementById("WebsquareSoft").style.display = "";
		} else {
			document.getElementById("WebsquareSoft").style.display = "none";
		}
	}

	function fn_init() {
<%if ("websquare".equals(licenseKind)) {%>
	document.getElementById("WebsquareSoft").style.display = "";
<%}%>
	}
</script>
</head>
<body onload="fn_init();">
	라이센스 발급
	<br />
	<form name="LicenseForm" method="post" action="/">

		<table>
			<tr>
				<td>License Kind</td>
				<td><select id="licenseKind" name="licenseKind"
					onchange="fn_selectKind();">
						<option value="proworks" <%if ("proworks".equals(licenseKind)) {%>
							selected <%}%>>PROWORKS</option>
						<option value="websquare"
							<%if ("websquare".equals(licenseKind)) {%> selected <%}%>>WEBSQUARE</option>
				</select></td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="WebsquareSoft" style="display: none">
						<table>
							<tr>
								<td width="115px">Soft Kind</td>
								<td><select name="websquareSoft">
										<option value="15" <%if ("15".equals(websquareSoft)) {%>
											selected <%}%>>push</option>
										<option value="14" <%if ("14".equals(websquareSoft)) {%>
											selected <%}%>>hybrid platform</option>
										<option value="13" <%if ("13".equals(websquareSoft)) {%>
											selected <%}%>>studio</option>
										<option value="12" <%if ("12".equals(websquareSoft)) {%>
											selected <%}%>>platform</option>
								</select></td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			<tr>
				<td>License Type</td>
				<td><select id="licenseType" name="licenseType"
					onchange="fn_licenseType_Change();">
						<option value="0" <%if ("0".equals(isDemo)) {%> selected <%}%>>Demo
							License</option>
						<option value="1" <%if ("1".equals(isDemo)) {%> selected <%}%>>Real
							License</option>
				</select></td>
			</tr>
<!-- 			<tr>
				<td>Customer Name</td>
				<td><input type="text" name="customerName"
					value="<%=customerName%>" /></td>
			</tr>  -->
			<tr>
				<td>Host Name</td>
				<td><input type="text" name="hostName" value="<%=hostname%>" />PassKey:"any"
				</td>
			</tr>
			<tr>
				<td>Server IP</td>
				<td><input type="text" name="serverIp" value="<%=ip%>" />PassKey:"0.0.0.0"||"127.0.0.1"
				</td>
			</tr>
			<tr>
				<td>CPU Count</td>
				<td><input type="text" name="cpuCount" value="<%=cpuNumber%>" />PassKey:999
				</td>
			</tr>
			<tr>
				<td>Expire Date</td>
				<td><input type="text" id="expiredate" name="expiredate"
					value="<%=expiredate%>" />YYYYMMDD</td>
			</tr>
			<tr>
				<td><input type="hidden" name="Makeflag" value="true" /></td>
				<td><input type="submit" value="생성" /></td>
			</tr>
			<tr>
				<td>License Key</td>
				<td><textarea id="result" style="width: 600px; height: 100px;"><%=retval%></textarea></td>
			</tr>
			<tr>
			<td>### 추가 ###</td>
			</tr>
			<tr>
				<td>라이선스 복호화</td>
				<td><textarea id="decodeLicense"
						style="width: 600px; height: 50px;"><%=coverted%></textarea></td>
			</tr>
		</table>
	</form>

	<form name="mailForm" method="post">
		<table>
			<tr>
				<td><input type="button" onclick="make();" value="라이선스 다운로드" /></td>
			</tr>
			<tr>
			<td>직원 정보</td>
			</tr>
			<tr>
				<td>Email</td>
				<td><input type="text" name="fromEmail" /> passwd <input type="password" name="fromPasswd" /></td>
			</tr>
			<tr>
				<td>name</td>
				<td><input type="text" name="fromName" /></td>
			</tr>
			<tr>
			<td>업체 정보</td>
			</tr>
			<tr>
				<td>company name</td>
				<td><input type="text" name="toCompany" /></td>
			</tr>
			<tr>
				<td>Email</td>
				<td><input type="text" name="toEmail" /></td>
			</tr>
			<tr>
				<td><input type="button" onclick="mail();" value="메일전송" /></td>
			</tr>
		</table>
	</form>
</body>
</html>
<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="value" required="true" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<fmt:formatNumber value="${value}" pattern="#,##0"/> VND

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../shared/header.jsp" %>
<div class="container mt-4">
    <h2>Transaction History</h2>
    <table class="table table-striped bg-white">
        <thead><tr><th>Item</th><th>Result</th><th>Date</th></tr></thead>
        <tbody>
        <c:forEach var="t" items="${transactions}">
            <tr>
                <td>${t.itemName}</td>
                <td>${t.result}</td>
                <td><fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="../shared/footer.jsp" %>

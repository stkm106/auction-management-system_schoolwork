<%-- 
    Document   : list
    Created on : Jun 24, 2026, 8:49:41 PM
    Author     : San
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<h3 class="mt-3">Auction Bids</h3>

<table class="table table-bordered">

    <thead class="table-dark">
    <tr>
        <th>Bid ID</th>
        <th>User ID</th>
        <th>Bid Amount</th>
        <th>Bid Time</th>
    </tr>
    </thead>

    <tbody>

    <c:forEach var="b" items="${bids}">
        <tr>
            <td>${b.bidID}</td>
            <td>${b.userID}</td>
            <td>${b.bidAmount}</td>
            <td>${b.bidTime}</td>
        </tr>
    </c:forEach>

    </tbody>

</table>

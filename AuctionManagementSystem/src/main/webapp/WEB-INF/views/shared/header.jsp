<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><c:if test="${not empty pageTitle}">${pageTitle} - </c:if>AuctionPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
    <%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
</head>
<body>

<header>
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <i class="fa-solid fa-gavel"></i> AuctionPro
    </a>
    <nav>
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/auctions">Auctions</a>
        <a href="${pageContext.request.contextPath}/categories">Categories</a>
        <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
        </c:if>
    </nav>
    <div class="header-btns">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/wallet" class="btn btn-login"><i class="fa-solid fa-wallet"></i> Wallet</a>
                <a href="${pageContext.request.contextPath}/my-bids" class="btn btn-login">My Bids</a>
                <a href="${pageContext.request.contextPath}/my-payments" class="btn btn-login">Payments</a>
                <a href="${pageContext.request.contextPath}/seller/products" class="btn btn-login">Sell</a>
                <span class="btn btn-login" style="cursor:default;color:var(--gold)">${sessionScope.user.fullName}</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-register">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-login">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-register">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

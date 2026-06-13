<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đấu giá</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 style="color:var(--navy);margin-bottom:24px">Quản lý đấu giá</h1>
        <table class="data-table">
            <thead><tr><th>ID</th><th>Sản phẩm</th><th>Giá</th><th>Cọc</th><th>TT</th><th>Kết thúc</th></tr></thead>
            <tbody>
            <c:forEach var="a" items="${auctions}">
                <tr>
                    <td>${a.auctionId}</td>
                    <td><strong>${a.productName}</strong></td>
                    <td><tags:formatVnd value="${a.currentPrice}"/></td>
                    <td><tags:formatVnd value="${a.depositAmount}"/></td>
                    <td><span class="badge badge-active">${a.status}</span></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/auctions/end" class="table-inline-form">
                            <input type="hidden" name="auctionId" value="${a.auctionId}">
                            <button class="btn-sm btn-sm-navy" type="submit" onclick="return confirm('Kết thúc phiên và chọn người thắng?')">
                                <i class="fa-solid fa-flag-checkered"></i> Kết thúc
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

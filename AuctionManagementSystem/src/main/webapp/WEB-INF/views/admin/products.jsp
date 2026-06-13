<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Duyệt sản phẩm</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link href="${pageContext.request.contextPath}/css/auctionpro.css" rel="stylesheet"/>
</head>
<body>
<div class="admin-wrap">
    <%@ include file="../shared/admin-sidebar.jsp" %>
    <div class="admin-main">
        <h1 style="color:var(--navy);margin-bottom:24px">Duyệt sản phẩm</h1>
        <table class="data-table">
            <thead><tr><th>ID</th><th>Tên</th><th>Người bán</th><th>Giá khởi điểm</th><th>TT</th><th>Duyệt</th></tr></thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>${p.productId}</td>
                    <td><strong>${p.name}</strong></td>
                    <td>${p.sellerName}</td>
                    <td><tags:formatVnd value="${p.startingPrice}"/></td>
                    <td><span class="badge badge-pending">${p.status}</span></td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/products/approve" class="table-inline-form">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <select name="status" class="form-control" style="min-width:140px">
                                <option value="APPROVED">APPROVED</option>
                                <option value="REJECTED">REJECTED</option>
                                <option value="AUCTIONING">AUCTIONING</option>
                            </select>
                            <button class="btn-sm btn-sm-gold" type="submit"><i class="fa-solid fa-check"></i> Lưu</button>
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

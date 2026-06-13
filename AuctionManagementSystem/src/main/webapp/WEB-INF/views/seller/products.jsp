<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Sản phẩm của tôi"/>
<%@ include file="../shared/header.jsp" %>

<section class="page-section">
    <div class="section-title" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;text-align:left">
        <div>
            <h2 style="margin-bottom:8px">Sản phẩm bán</h2>
            <p style="margin:0">Quản lý sản phẩm và tạo phiên đấu giá</p>
        </div>
        <a href="${pageContext.request.contextPath}/seller/product-form" class="btn-gold" style="padding:14px 24px;border-radius:12px;display:inline-flex;align-items:center;gap:8px">
            <i class="fa-solid fa-plus"></i> Thêm sản phẩm
        </a>
    </div>

    <table class="data-table">
        <thead>
            <tr><th>Tên</th><th>Giá khởi điểm</th><th>Trạng thái</th><th>Tạo phiên đấu giá</th></tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td><strong>${p.name}</strong></td>
                <td><tags:formatVnd value="${p.startingPrice}"/></td>
                <td><span class="badge badge-pending">${p.status}</span></td>
                <td>
                    <c:if test="${p.status == 'APPROVED' || p.status == 'AUCTIONING'}">
                        <form method="post" action="${pageContext.request.contextPath}/seller/auction/create" class="table-inline-form">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <div class="form-group" style="min-width:180px">
                                <label class="form-label">Bắt đầu</label>
                                <input class="form-control" type="datetime-local" name="startTime" required>
                            </div>
                            <div class="form-group" style="min-width:180px">
                                <label class="form-label">Kết thúc</label>
                                <input class="form-control" type="datetime-local" name="endTime" required>
                            </div>
                            <button class="btn-sm btn-sm-gold" type="submit"><i class="fa-solid fa-gavel"></i> Bắt đầu</button>
                        </form>
                    </c:if>
                    <c:if test="${p.status != 'APPROVED' && p.status != 'AUCTIONING'}">
                        <span style="color:#999;font-size:13px">Chờ duyệt sản phẩm</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</section>

<%@ include file="../shared/footer.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Danh mục"/>
<%@ include file="../shared/header.jsp" %>
<section class="page-section">
    <h2 style="color:var(--navy);margin-bottom:24px">Danh mục sản phẩm</h2>
    <div class="features-grid">
        <c:forEach var="cat" items="${categories}">
            <div class="feature-card">
                <i class="fa-solid fa-tag"></i>
                <h3>${cat.name}</h3>
                <p>${cat.description}</p>
                <a href="${pageContext.request.contextPath}/auctions?categoryId=${cat.categoryId}" class="btn-navy" style="display:inline-block;margin-top:12px">Xem đấu giá</a>
            </div>
        </c:forEach>
    </div>
</section>
<%@ include file="../shared/footer.jsp" %>

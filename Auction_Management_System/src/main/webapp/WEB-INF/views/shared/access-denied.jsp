<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Truy cập bị từ chối"/>
<%@ include file="header.jsp" %>
<div class="auth-page">
    <div class="form-box" style="text-align:center">
        <h2 style="color:var(--navy);margin-bottom:12px"><i class="fa-solid fa-ban text-gold"></i> Truy cập bị từ chối</h2>
        <p style="color:#666;margin-bottom:24px">Bạn không có quyền truy cập trang này.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn-navy" style="display:inline-block;width:auto;padding:14px 32px;text-decoration:none;border-radius:10px">Về trang chủ</a>
    </div>
</div>
<%@ include file="footer.jsp" %>

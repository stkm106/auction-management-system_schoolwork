<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="detail-card" style="max-width:480px;margin:2rem auto">
    <h4 class="mb-3">Nạp tiền vào ví</h4>
    <form method="post" action="${ctx}/wallet/deposit">
        <div class="mb-3">
            <label class="form-label">Số tiền nạp</label>
            <input type="number" name="amount" class="form-control form-control-lg" min="1000" step="1000" required>
        </div>
        <button type="submit" class="btn btn-gold w-100">Xác nhận nạp tiền</button>
        <a href="${ctx}/wallet" class="btn btn-outline-secondary w-100 mt-2">Quay lại</a>
    </form>
</div>

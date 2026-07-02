<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="page-header">
    <div>
        <h1>Tạo phiên đấu giá</h1>
        <div class="breadcrumb-custom">Trang chủ &gt; Quản lý phiên đấu giá &gt; Tạo mới</div>
    </div>
</div>

<div class="profile-card">
    <div class="profile-card-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${empty products}">
            <div class="alert alert-warning mb-0">
                Hiện không có sản phẩm nào đã duyệt và chưa có phiên đấu giá.
            </div>
        </c:if>
        <form method="post" action="${ctx}/auctions/create">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Sản phẩm</label>
                    <select name="productID" id="auctionProductID" class="form-select" required ${empty products ? 'disabled' : ''}>
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="p" items="${products}">
                            <option value="${p.productID}"
                                    data-starting-price="${p.startingPrice}"
                                    ${auction.productID == p.productID ? 'selected' : ''}>
                                ${p.productID} - ${p.productName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Giá hiện tại</label>
                    <input type="number" name="currentPrice" id="auctionCurrentPrice" class="form-control"
                           value="${auction.currentPrice}" min="1" step="1000" required readonly>
                    <div class="form-text">Tự động lấy từ giá khởi điểm người đăng đã khai báo khi chờ duyệt.</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Thời gian bắt đầu</label>
                    <c:choose>
                        <c:when test="${not empty auction.startTime}">
                            <c:set var="startTimeValue"><fmt:formatDate value="${auction.startTime}" pattern="yyyy-MM-dd'T'HH:mm"/></c:set>
                        </c:when>
                        <c:otherwise>
                            <c:set var="startTimeValue">${startTimeRaw}</c:set>
                        </c:otherwise>
                    </c:choose>
                    <input type="datetime-local" name="startTime" id="auctionStartTime" class="form-control" step="60"
                           value="${startTimeValue}" required>
                    <div class="form-text">Phải chọn thời điểm trong tương lai.</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Thời gian kết thúc</label>
                    <c:choose>
                        <c:when test="${not empty auction.endTime}">
                            <c:set var="endTimeValue"><fmt:formatDate value="${auction.endTime}" pattern="yyyy-MM-dd'T'HH:mm"/></c:set>
                        </c:when>
                        <c:otherwise>
                            <c:set var="endTimeValue">${endTimeRaw}</c:set>
                        </c:otherwise>
                    </c:choose>
                    <input type="datetime-local" name="endTime" id="auctionEndTime" class="form-control" step="60"
                           value="${endTimeValue}" required>
                    <div class="form-text">Phiên phải kéo dài ít nhất 5 phút. Thời gian bắt đầu và kết thúc đều phải ở tương lai.</div>
                </div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn btn-gold" ${empty products ? 'disabled' : ''}>Tạo phiên đấu giá</button>
                <a href="${ctx}/auctions/manage" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<script>
(function () {
    const productSelect = document.getElementById('auctionProductID');
    const priceInput = document.getElementById('auctionCurrentPrice');
    if (!productSelect || !priceInput) {
        return;
    }

    function syncPriceFromProduct() {
        const selected = productSelect.options[productSelect.selectedIndex];
        const startingPrice = selected ? selected.getAttribute('data-starting-price') : null;
        if (startingPrice) {
            priceInput.value = startingPrice;
        } else {
            priceInput.value = '';
        }
    }

    productSelect.addEventListener('change', syncPriceFromProduct);
    syncPriceFromProduct();

    const startInput = document.getElementById('auctionStartTime');
    const endInput = document.getElementById('auctionEndTime');

    function toDateTimeLocalValue(date) {
        const pad = function (n) { return String(n).padStart(2, '0'); };
        return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate())
                + 'T' + pad(date.getHours()) + ':' + pad(date.getMinutes());
    }

    function applyFutureDateLimits() {
        if (!startInput || !endInput) {
            return;
        }
        const now = new Date();
        const minValue = toDateTimeLocalValue(now);
        startInput.min = minValue;
        endInput.min = minValue;
        if (startInput.value) {
            endInput.min = startInput.value;
        }
    }

    if (startInput) {
        startInput.addEventListener('change', applyFutureDateLimits);
    }
    applyFutureDateLimits();
})();
</script>
